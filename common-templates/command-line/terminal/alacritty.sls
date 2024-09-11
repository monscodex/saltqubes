alacritty:
  pkg.installed


/etc/alacritty:
  file.directory:
    - user: root
    - group: root
    - mode: 755


default_alacrittyconfig:
  file.managed:
    - name: /etc/alacritty/alacritty.toml
    - source: salt://dotfiles/alacritty/alacritty.toml
