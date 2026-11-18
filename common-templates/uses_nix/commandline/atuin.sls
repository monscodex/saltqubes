{{ slsdotpath }}_install_atuin_with_nix:
  module.run:
    - name: nix.install
    - pkgs:
      - nixpkgs.atuin
    - kwargs: {attributes: True}


{% set system_dir = "/usr/share/custom_saltqubes_storage_dir/atuin/" %}
{% set atuin_minion_config_dir = '/home/user/.config/atuin' %}

{{ slsdotpath }}_link_atuin_config_on_boot:
  module.run:
    - name: link_on_boot.link
    - link_path: {{ atuin_minion_config_dir }}
    - source_path: {{ system_dir }}

{{ slsdotpath }}_create_shared_atuin_conf_dir:
  file.directory:
    - name: {{ system_dir }}
    - user: user
    - group: user
    - dir_mode: 777
    - makedirs: True

{{ slsdotpath }}_copy_atuin_config_directory:
  file.recurse:
    - name: {{ atuin_minion_config_dir }}
    - source: salt://dotfiles/atuin
    - user: user
    - group: user
    - dir_mode: 755
    - file_mode: 444
