def remove-color [] {
	$in| str replace --all -r '\p{C}\[\d+;\d+m' ''
}

def strip-dash-line [] {
	$in| str replace --regex --multiline --all '\n^.*-{10,}.*$' ''
}

def "qubesctl-nu top.enabled" [] {
	qubesctl top.enabled | remove-color | strip-dash-line | from yaml;
}

def "qubesctl-nu top.enabled.local.names" [] {
	let a = (qubesctl-nu top.enabled) | get --ignore-errors local.user;

	if ($a | is-empty) {
		[];
	} else {
		$a | each {|e| $e | path basename | str replace --regex '.top$' '' }
	}
}

def "x1-nu list" [] {
	xl list | detect columns | update Mem {|row| ($row.Mem + 'MiB') | into filesize} | update "Time(s)" {($in + 'sec') | into duration}
}
