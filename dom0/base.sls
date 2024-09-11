{% from "dom0/get_user.jinja" import dom0_user %}

{{ slsdotpath }}_install_packages:
  cmd.run:
    - name: qubes-dom0-update -y rofi flameshot redshift adwaita-qt5



{{ slsdotpath }}_copy_qubes-tools:
  file.recurse:
    - name: /opt/qubes-tools/
    - source: salt://{{ slsdotpath }}/files/qubes-tools/
    - user: root
    - group: root
    - file_mode: '0555'
    - dir_mode: '0755'
    - makedirs: True



{{ slsdotpath }}_copy_xfce4_settings:
  file.recurse:
    - name: /home/{{ dom0_user }}/.config/xfce4/xfconf/
    - source: salt://dotfiles/xfce4/xfconf/
    - user: root
    - group: root
    - file_mode: '0666'
    - dir_mode: '0755'
    - makedirs: True



{{ slsdotpath }}_copy_rofi_settings:
  file.recurse:
    - name: /home/{{ dom0_user }}/.config/rofi/
    - source: salt://dotfiles/rofi/
    - user: root
    - group: root
    - file_mode: '0555'
    - dir_mode: '0755'
    - makedirs: True



{% set redshift_config_path='/home/' ~ dom0_user ~ '/.config/redshift/redshift.conf' %}

/home/{{ dom0_user }}/.config/redshift:
  file.directory:
    - user: root
    - group: root
    - mode: 755

{{ slsdotpath }}_copy_redshift_config:
  file.managed:
    - name: {{ redshift_config_path }}
    - source: salt://dotfiles/redshift/redshift.conf
    - mode: '444'



{{ slsdotpath }}_copy_user_startup_script:
  file.managed:
    - name: /home/{{ dom0_user }}/.config/user-startup-script
    - source: salt://{{ slspath }}/files/user-startup-script
    - template: jinja
    - user: root
    - group: root
    - mode: 555
    - defaults:
      dom0_user: {{ dom0_user }}
      redshift_config_path: {{ redshift_config_path }}

{{ slsdotpath }}_copy_user_startup_script_xfce4_init:
  file.managed:
    - name: /home/{{ dom0_user }}/.config/autostart/user-startup-script.desktop
    - source: salt://{{ slsdotpath }}/files/user-startup-script.desktop
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - makedirs: True
    - defaults:
      dom0_user: {{ dom0_user }}


{{ slsdotpath }}_warn_about_zoo_ticket:
  test.fail_without_changes:
    - name: "Don't forget to export ZOO_TICKET variable in you /home/{{ dom0_user }}/.bashrc"
    - failhard: False



{{ slsdotpath }}_copy_move_to_next_monitor_bin:
  file.managed:
    - name: /opt/move-to-next-monitor
    - source: salt://{{ slsdotpath }}/files/move-to-next-monitor
    - mode: 555



{{ slsdotpath }}_copy_pulsemixer_bin:
  file.managed:
    - name: /opt/pulsemixer
    - source: salt://{{ slsdotpath }}/files/pulsemixer
    - mode: 555

{{ slsdotpath }}_copy_pulsemixer_config:
  file.managed:
    - name: /home/{{ dom0_user }}/.config/pulsemixer.cfg
    - source: salt://dotfiles/pulsemixer.cfg
    - mode: 444



{{ slsdotpath }}_dark_theme_delete_QT_STYLE_ENV_VAR:
  cmd.run:
    - name: sed -i '/QT_STYLE_OVERRIDE/d' /etc/environment

{{ slsdotpath }}_append_dark_theme_variable_to_file:
  file.append:
    - name: /etc/environment
    - text: "QT_STYLE_OVERRIDE=adwaita-dark"
