{% if grains['nodename'] == 'dom0' %}



{{ slsdotpath }}_dom0_install:
  cmd.run:
    - name: qubes-dom0-update -y nu
    - runas: root


{% from "dom0/get_user.jinja" import dom0_user %}

{% for dom0_home in ['/root', ('/home/' ~ dom0_user) ]%}

{% set config_dir = dom0_home ~ '/.config/nushell' %}

{{ slsdotpath }}_copy_nushell_config_directory_{{ config_dir }}:
  file.recurse:
    - name: {{ config_dir }}
    - source: salt://dotfiles/nushell
    - user: {{ dom0_user }}
    - group: {{ dom0_user }}
    - dir_mode: 755
    - file_mode: 444


{{ slsdotpath }}_modify_permissions_nushell_binaries_{{ config_dir }}:
  file.recurse:
    - name: {{ config_dir }}/bin
    - source: salt://dotfiles/nushell/bin
    - user: {{ dom0_user }}
    - group: {{ dom0_user }}
    - file_mode: 555
    - replace: False



{{ slsdotpath }}_create_aliases_file_dom0_{{ config_dir }}:
  file.touch:
    - name: {{ config_dir }}/aliases.nu

{{ slsdotpath }}_create_atuin_file_dom0_{{ dom0_home }}:
  file.touch:
    - name: {{ dom0_home }}/.local/share/atuin/init.nu
    - makedirs: True

{{ slsdotpath }}_create_carapace_file_dom0_{{ dom0_home }}:
  file.touch:
    - name: {{ dom0_home }}/.cache/carapace/init.nu
    - makedirs: True


{% endfor %}


{# Do NOT put nushell as default shell #}




{% else %}




{{ slsdotpath }}_install_nushell_with_nix:
  module.run:
    - name: nix.install
    - pkgs:
      - nixpkgs.nushell
      - nixpkgs.atuin
      - nixpkgs.carapace
      - nixpkgs.trash-cli
      - nixpkgs.nushellPlugins.query
      - nixpkgs.nushellPlugins.polars
      - nixpkgs.nushellPlugins.formats
    - kwargs: {attributes: True}

{{ slsdotpath }}_set_user_shell_to_nushell:
  user.present:
    - name: user
    - shell: /nix/var/nix/profiles/default/bin/nu


{% set system_dir = "/usr/share/custom_saltqubes_storage_dir/nushell/config/" %}
{% set nushell_minion_config_dir = '/home/user/.config/nushell' %}

{{ slsdotpath }}_link_nushell_config_on_boot:
  module.run:
    - name: link_on_boot.link
    - link_path: {{ nushell_minion_config_dir }}
    - source_path: {{ system_dir }}

{{ slsdotpath }}_create_shared_nushell_conf_dir:
  file.directory:
    - name: {{ system_dir }}
    - user: user
    - group: user
    - dir_mode: 777
    - makedirs: True

{{ slsdotpath }}_copy_nushell_config_directory:
  file.recurse:
    - name: {{ nushell_minion_config_dir }}
    - source: salt://dotfiles/nushell
    - user: user
    - group: user
    - dir_mode: 755
    - file_mode: 444


{{ slsdotpath }}_modify_permissions_nushell_binaries:
  file.recurse:
    - name: {{ nushell_minion_config_dir }}/bin
    - source: salt://dotfiles/nushell/bin
    - user: user
    - group: user
    - file_mode: 555
    - replace: False

    # Now handled by nushell config
      #{{ slsdotpath }}_generate_nushell_aliases:
      #cmd.run:
      #- name: nu {{ nushell_minion_config_dir }}/bin/gen-aliases.nu
      #- shell: /usr/bin/bash
      #- runas: user

{{ slsdotpath }}_create_aliases_file:
  file.managed:
    - name: {{ nushell_minion_config_dir }}/aliases.nu



# ATUIN history
{% set atuin_dir = '/home/user/.local/share/atuin' %}

{{ slsdotpath }}_mkdir_autin_history_directory:
  file.directory:
    - name: {{ atuin_dir }}
    - user: user
    - group: user
    - mode: 755


{{ slsdotpath }}_generate_atuin_nushell_config:
  cmd.run:
    - name: atuin init nu > {{ atuin_dir }}/init.nu
    - shell: /usr/bin/bash
    - runas: user


{% endif %}

{{ slsdotpath }}_delete_etc_profile_experimental_options:
  file.replace:
    - name: /etc/profile
    - pattern: '^.*# SALT_ADD_NUSHELL$'
    - repl: ''

{{ slsdotpath }}_append_etc_profile_experimental_options:
  file.append:
    - name: /etc/profile
    - text: 'export NU_EXPERIMENTAL_OPTIONS="native-clip" # SALT_ADD_NUSHELL'
