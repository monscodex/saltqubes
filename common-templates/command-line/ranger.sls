{{ slsdotpath }}_install_ranger:
  pkg.installed:
    - name: ranger

{{ slsdotpath }}_copy_ranger_config:
  file.recurse:
    - name: /etc/ranger/
    - source: salt://dotfiles/ranger/
    - user: root
    - group: root
    - file_mode: '0555'
    - dir_mode: '0755'
    - makedirs: True
