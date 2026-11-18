#!/usr/bin/env nu

let aliases_file = $nu.default-config-dir | path join aliases.nu

def save-alias [...args: string] {
    $"alias ($args | str join ' ')\n" | save -a $aliases_file
}

# overwrite file with empty string
'' | save -f $aliases_file


def command_exists [command_name] {
    not ((which $command_name) | is-empty)
}


#if (command_exists exa) {
#   save-alias "eza = exa"
#}

#if (command_exists eza) {
#    save-alias "ls = eza --color=always --icons --group-directories-first"
#    save-alias "tree = ls -at"
#}

#save-alias "l = ls -l"
#save-alias "lt = tree"


save-alias "grep = grep --color=auto --ignore-case"
save-alias "egrep = egrep --color=auto --ignore-case"
save-alias "fgrep = fgrep --color=auto --ignore-case"


save-alias "cp = cp -i"
save-alias "mv = mv -i"

if (command_exists trash-put) {
    save-alias "rmforreal = /usr/bin/rm -i"
    save-alias "rm = trash-put"
}

save-alias "df = df -h"
save-alias "free = free -m"

if (command_exists yt-dlp) {
  save-alias "yta-aac = yt-dlp --extract-audio --audio-format aac"
  save-alias "yta-best = yt-dlp --extract-audio --audio-format best"
  save-alias "yta-flac = yt-dlp --extract-audio --audio-format flac"
  save-alias "yta-m4a = yt-dlp --extract-audio --audio-format m4a"
  save-alias "yta-mp3 = yt-dlp --extract-audio --audio-format mp3"
  save-alias "yta-opus = yt-dlp --extract-audio --audio-format opus"
  save-alias "yta-vorbis = yt-dlp --extract-audio --audio-format vorbis"
  save-alias "yta-wav = yt-dlp --extract-audio --audio-format wav"
  save-alias "ytv-best = yt-dlp -f bestvideo+bestaudio"
}

save-alias "rr = do { http get https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash }"

if (command_exists batcat) {
    save-alias "bat = batcat"
}

if (command_exists bat) {
    save-alias "cat = bat"
}

if (command_exists dust) {
    save-alias "du = dust"
}

if (command_exists difft) {
    save-alias "diff = difft"
}



if (command_exists ranger) {
    save-alias "ranger = do --env {
        let ranger_dir_filename = [
            .rangerdir
            (date now | format date %s)
        ] | str join

        let ranger_dir_path = [
            $env.home
            .cache
            $ranger_dir_filename
        ] | path join

        with-env {term: xterm-256color} {
            /usr/bin/ranger --choosedir=($ranger_dir_path)
        }

        cd (open $ranger_dir_path)
    }"
}
