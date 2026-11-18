{{ slsdotpath }}_install_with_nix:
  module.run:
    - name: nix.install
    - pkgs:
      - nixpkgs.zellij
    - kwargs: {attributes: True}

{% set system_dir = "/usr/share/custom_saltqubes_storage_dir/zellij/config/" %}

{{ slsdotpath }}_link_config_on_boot:
  module.run:
    - name: link_on_boot.link
    - link_path: /home/user/.config/zellij
    - source_path: {{ system_dir }}

{{ slsdotpath }}_create_shared_config_dir:
  file.directory:
    - name: {{ system_dir }}
    - user: user
    - group: user
    - dir_mode: 777
    - makedirs: True

{{ slsdotpath }}_copy_zellij_config:
  file.recurse:
    - source: salt://dotfiles/zellij/
    - name: {{ system_dir }}
    - clean: True
    - force: True
    - user: user
    - group: user
