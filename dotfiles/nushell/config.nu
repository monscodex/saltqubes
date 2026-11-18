def command_exists [command_name] { not ((which $command_name) | is-empty) }

let aliases_file = $nu.default-config-dir | path join aliases.nu
let gen_aliases_file = $nu.default-config-dir | path join bin/gen-aliases.nu

def get_mod_time_of [myfile] { (ls $myfile | get modified | first) }


# If the gen aliases file is more recent than the aliases file
if ( (get_mod_time_of $aliases_file) <= (get_mod_time_of $gen_aliases_file) ) {
    printf `[Info]: recompiled aliases\n`

    # retype to avoid parsing error
    source ($nu.default-config-dir | path join bin/gen-aliases.nu)
}

# Aliases
# retype to avoid parsing error
source ($nu.default-config-dir | path join aliases.nu)

if (command_exists nvim) {
    $env.editor = "nvim"
    $env.manpager = "nvim +Man!"
}

if (command_exists difft) {
    $env.git_external_diff = "difft"
}

def remove-color [] {
	$in| str replace --all -r '\p{C}\[\d+;\d+m' ''
}

def strip-dash-line [] {
	$in| str replace --regex --multiline --all '\n^.*-{10,}.*$' ''
}

def "qubesctl-nu top.enabled" [] {
	if (not (command_exists qubesctl)) { return }

	qubesctl top.enabled | remove-color | strip-dash-line | from yaml
}

def "qubesctl-nu top.enabled.local.names" [] {
	if (not (command_exists qubesctl)) { return }

	let a = (qubesctl-nu top.enabled) | get --ignore-errors local.user;

	if ($a | is-empty) {
		[];
	} else {
		$a | each {|e| $e | path basename | str replace --regex '.top$' '' }
	}
}

def "x1-nu list" [] {
	if (not (command_exists xl)) { return }

	xl list | detect columns | update Mem {|row| ($row.Mem + 'MiB') | into filesize} | update "Time(s)" {($in + 'sec') | into duration}
}

def "qvm-volume-nu list" [] {
	if (not (command_exists qvm-volume)) { return }

	qvm-volume list | detect columns | rename --block {str downcase} | update revert_possible {$in == Yes}
}


$env.config.buffer_editor = $env.editor

def --env y [...args] {
	if not (command_exists yazi) { return }

	let tmp = (mktemp -t "yazi-cwd.XXXXXXXX")

	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.pwd and ($cwd | path exists) {
		cd $cwd
	}

	rm -fp $tmp
}


# Nushell, no kj escape, no vi mode
# $env.config.edit_mode = "vi"

$env.config.completions.algorithm = "fuzzy"

#$env.config.filesize.unit = "metric"
$env.config.float_precision = 4

$env.config.keybindings = [
    {
        name: delete_one_word_backward
        modifier: alt
        keycode: backspace
        mode: [emacs vi_insert]
        event: {edit: backspaceword}
    }
    {
        name: open_command_editor
        modifier: control
        keycode: char_o
        mode: [emacs vi_normal vi_insert]
        event: {send: openeditor}
    }
    {
        name: move_up
        modifier: alt
        keycode: char_k
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                {send: menuup}
                {send: up}
            ]
        }
    }
    {
        name: move_down
        modifier: alt
        keycode: char_j
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                {send: menudown}
                {send: down}
            ]
        }
    }
    {
        name: move_one_word_right_or_take_history_hint
        modifier: alt
        keycode: char_l
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                {send: historyhintwordcomplete}
                {edit: movewordright}
            ]
        }
    }
    {
        name: move_one_word_left
        modifier: alt
        keycode: char_h
        mode: [emacs vi_normal vi_insert]
        event: {edit: movewordleft}
    }
    {
        name: move_left
        modifier: control
        keycode: char_h
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                {send: menuleft}
                {send: left}
            ]
        }
    }
    {
        name: move_right
        modifier: control
        keycode: char_l
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                {send: menuright}
                {send: right}
            ]
        }
    }
]

# Atuin
source ~/.local/share/atuin/init.nu

# Carapace completion
source ~/.cache/carapace/init.nu


# Starship prompt
if (command_exists starship) {
    mkdir ($nu.data-dir | path join "vendor/autoload")

    $env.starship_config = "/etc/starship.toml"

    starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
}

# When installing nushell plugins through nix, they appear as commands, this will add the plugins
for nix_command in [
    nu_plugin_formats
    nu_plugin_polars
    nu_plugin_query
    ] {

    if (which $nix_command | is-not-empty) {
        plugin add (which $nix_command | first | get path)
    }
}

printf "> plugins list\n"

plugin list | select name version
