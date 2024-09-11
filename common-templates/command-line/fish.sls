{% if grains['nodename'] == 'dom0' %}


{{ slsdotpath }}_dom0_install_fish:
  cmd.run:
    - name: qubes-dom0-update -y fish
    - runas: root

{% from "dom0/get_user.jinja" import dom0_user %}

{{ slsdotpath }}_dom0_change_shell_to_fish:
  user.present:
    - name: {{ dom0_user }}
    - shell: /usr/bin/fish


{% else %}


{{ slsdotpath }}_qube_install_fish:
  pkg.installed:
    - name: fish

{{ slsdotpath }}_user_change_shell_to_fish:
  user.present:
    - name: user
    - shell: /usr/bin/fish


{% endif %}


{{ slsdotpath }}_root_change_shell_to_fish:
  user.present:
    - name: root
    - shell: /usr/bin/fish


{{ slsdotpath }}_copy_default_fish_config:
  file.managed:
    - name: /etc/fish/config.fish
    - source: salt://dotfiles/fish/config.fish
    - mode: 444
