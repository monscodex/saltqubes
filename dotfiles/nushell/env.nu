def command_exists [command_name] { not ((which $command_name) | is-empty) }

# Nix setup
#with-env { nix_link: ($env.home | path join .nix-profile)} {
    #$env.xdg_data_dirs = [
        #$env.xdg_data_dirs
        #/usr/local/share
        #/nix/var/nix/profiles/default/share
        #($env.nix_link | path join share)
    #] | str join (char esep)
#
    #$env.nix_profiles = [
        #"/nix/var/nix/profiles/default"
        #($env.home | path join .nix-profile)
    #] | str join " "
#
    #for $ssl_path in [
        #/etc/ssl/certs/ca-certificates.crt
        #/etc/ssl/ca-bundle.pem
        #/etc/ssl/certs/ca-bundle.crt
        #/etc/pki/tls/certs/ca-bundle.crt
        #($env.nix_link | path join etc/ssl/certs/ca-bundle.crt)
        #($env.nix_link | path join etc/ca-bundle.crt)
    #] {
        #if ($ssl_path | path exists) {
            #$env.nix_ssl_cert_file = $ssl_path | path join "hasdfasdf"
            #break
        #}
    #}
#
    #$env.path | append ($env.nix_link | path join bin)
#}



if (command_exists atuin) {
	# Disable nushell, managed history because I use the history managed by atuin! just hit Ctrl+R!!
	$env.config.history.path = null
}


if (command_exists carapace) {
	# Carapace completion
	$env.carapace_bridges = 'zsh,fish,bash,inshellisense'
	mkdir ~/.cache/carapace
	carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
}
