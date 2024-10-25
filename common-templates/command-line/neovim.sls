{% if grains['nodename'] == 'dom0' %}


{{ slsdotpath }}_install_nvim:
  cmd.run:
    - name: qubes-dom0-update -y neovim python3-neovim
    - runas: root


{% elif grains['os_family'] == 'Debian' %}


{{ slsdotpath }}_download_neovim_deb:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082 https://github.com/neovim/neovim/releases/download/v0.8.3/nvim-linux64.deb -o /tmp/nvim-linux64.deb

{{ slsdotpath }}_verify_neovim_deb:
  file.managed:
    - name: /tmp/nvim-linux64.hashok.deb
    - source: /tmp/nvim-linux64.deb
    - source_hash: 0828910da0b532e7564b1d200645bd846e6b2e1d10aa3111e36b59c1521b16f0

{{ slsdotpath }}_install_neovim_deb:
  pkg.installed:
    - name: neovim
    - sources:
      - neovim: /tmp/nvim-linux64.hashok.deb

{{ slsdotpath }}_clean_neovim_deb:
  file.absent:
    - name: /tmp/nvim-linux64.deb

{{ slsdotpath }}_clean_verified_neovim_deb:
  file.absent:
    - name: /tmp/nvim-linux64.hashok.deb


{% elif grains['os_family'] == 'RedHat' %}


{{ slsdotpath }}_install_neovim:
  pkg.installed:
    - name: neovim


{% endif %}



{% if grains['os_family'] in ['RedHat', 'Debian'] %}

{{ slsdotpath }}_install_neovim_python_support:
  pkg.installed:
    - name: python3-neovim

{% endif %}


{{ slsdotpath }}_make_neovim_etc_dir:
  file.directory:
    - name: /etc/nvim
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644

{{ slsdotpath }}_make_neovim_undodir:
  file.directory:
    - name: /etc/nvim/undodir
    - user: root
    - group: root
    - dir_mode: 777
    - file_mode: 666

{{ slsdotpath }}_copy_neovim_config:
  file.managed:
    - name: /etc/nvim/init.lua
    - source: salt://dotfiles/nvim/init.lua
    - user: root
    - group: root
    - mode: 444
