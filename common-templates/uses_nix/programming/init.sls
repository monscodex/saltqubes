{{ slsdotpath }}_install_programming_tools_with_nix:
  module.run:
    - name: nix.install
    - pkgs:
      - nixpkgs.hugo
      - nixpkgs.yazi
      - nixpkgs.dragon-drop
    - kwargs: {attributes: True}

{% set system_dir = "/usr/share/custom_saltqubes_storage_dir/yazi/config/" %}

{{ slsdotpath }}_link_yazi_config_on_boot:
  module.run:
    - name: link_on_boot.link
    - link_path: /home/user/.config/yazi
    - source_path: {{ system_dir }}

{{ slsdotpath }}_create_shared_config_dir:
  file.directory:
    - name: {{ system_dir }}
    - user: user
    - group: user
    - dir_mode: 777
    - makedirs: True

{{ slsdotpath }}_copy_yazi_config:
  file.recurse:
    - source: salt://dotfiles/yazi/
    - name: {{ system_dir }}
    - clean: True
    - force: True
    - user: user
    - group: user
