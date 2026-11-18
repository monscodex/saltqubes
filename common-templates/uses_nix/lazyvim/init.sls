{{ slsdotpath }}_install_dependencies:
  pkg.installed:
    - pkgs:
      - git
      - fzf
      - fd-find
      - ripgrep

{{ slsdotpath }}_install_neovim_with_nix:
  module.run:
    - name: nix.install
    - pkgs:
      - nixpkgs.neovim
    - kwargs: {attributes: True}

{% set system_dir = "/usr/share/custom_saltqubes_storage_dir/neovim/config/" %}

{{ slsdotpath }}_link_neovim_config_on_boot:
  module.run:
    - name: link_on_boot.link
    - link_path: /home/user/.config/nvim
    - source_path: {{ system_dir }}

{{ slsdotpath }}_create_shared_nvim_conf_dir:
  file.directory:
    - name: {{ system_dir }}
    - user: user
    - group: user
    - dir_mode: 777
    - makedirs: True

# Only cloned if it is not cloned already
{% if not salt['file.file_exists']('/home/user/.config/nvim/.git') %}
{{ slsdotpath }}_install_lazyvim:
  cmd.run:
    - name: rm -rf /tmp/test && git clone https://github.com/LazyVim/starter /tmp/test && rm -rf /home/user/.config/nvim/* /home/user/.config/nvim/.* && mv /tmp/test/* /home/user/.config/nvim/ && mv /tmp/test/.* /home/user/.config/nvim/
    - runas: user
    - env:
      - https_proxy: http://localhost:8082
{% endif %}


{{ slsdotpath }}_backup_config/lazy.lua:
  file.copy:
    - name: /tmp/lazy.lua
    - source: /home/user/.config/nvim/lua/config/lazy.lua
    - force: True


{{ slsdotpath }}_copy_lazyvim_.config/nvim/lua/config:
  file.recurse:
    - source: salt://{{slspath}}/files/nvim_config/lua/config
    - clean: True
    - name: /home/user/.config/nvim/lua/config
    - user: user
    - group: user

{{ slsdotpath }}_restore_config/lazy.lua:
  file.copy:
    - name: /home/user/.config/nvim/lua/config/lazy.lua
    - source: /tmp/lazy.lua
    - force: True


{{ slsdotpath }}_copy_lazyvim_.config/nvim/lua/plugins:
  file.recurse:
    - source: salt://{{slspath}}/files/nvim_config/lua/plugins
    - clean: True
    - name: /home/user/.config/nvim/lua/plugins
    - user: user
    - group: user
