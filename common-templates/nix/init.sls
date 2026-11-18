
{{ slsdotpath }}_add_nixbld_group:
  group.present:
    - name: nixbld

{{ slsdotpath }}_add_nixbld_user:
  user.present:
    - name: nixbld
    - gid: nixbld
    - createhome: False

{{ slsdotpath }}_install_xz:
  pkg.installed:
    - pkgs:
{% if grains['os_family'] == 'Debian' %}
      - xz-utils
{% elif grains['os_family'] == 'RedHat' %}
      - xz
{% endif %}
    - skip_suggestions: True
    - install_recommends: False
    - order: 1


# Somewhy user.present is not enough
{{ slsdotpath }}_fix_nixbld_bug:
  cmd.run:
    - name: usermod -aG nixbld nixbld
    - runas: root

# We are going to enable passwordless root momentarily, not permanently.
{% set was_passwordless_root_installed = not not salt['pkg.version']("qubes-core-agent-passwordless-root") %}

{{ slsdotpath }}_enable_passwordless_access:
  pkg.installed:
    - name: qubes-core-agent-passwordless-root

# Base Installation of nix as a the regular user (needed as installing for the first time as root does not work)
{{ slsdotpath }}_run_nix_installation_script_as_user:
  cmd.run:
    - name: sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon --yes
    - runas: user
    - env:
      - https_proxy: http://localhost:8082


{% if not was_passwordless_root_installed %}

{{ slsdotpath }}_disable_passwordless_access:
  pkg.removed:
    - name: qubes-core-agent-passwordless-root

{% endif %}

# Now we run the script as root, this creates the .../profiles/default/ profile, symlinked to the nix profile for the root user.
{{ slsdotpath }}_run_nix_installation_script_as_root:
  cmd.run:
    - name: sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon --yes
    - runas: root
    - env:
      - https_proxy: http://localhost:8082


{{ slsdotpath }}_delete_etc_profile_path:
  file.replace:
    - name: /etc/profile
    - pattern: '^.*# SALT_ADD_NIX$'
    - repl: ''

{{ slsdotpath }}_append_etc_profile_path:
  file.append:
    - name: /etc/profile
    - text: 'export PATH="/nix/var/nix/profiles/default/bin:$PATH"; export XDG_DATA_DIR="/nix/var/nix/profiles/default/share:$XDG_DATA_DIR;" # SALT_ADD_NIX'
