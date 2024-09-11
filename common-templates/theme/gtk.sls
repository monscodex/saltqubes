{{ slsdotpath }}_mkdir_etc_gtk2.0:
  file.directory:
    - name: /etc/gtk-2.0
    - makedirs: True
    - user: root
    - group: root

{{ slsdotpath }}_copy_gtk2_config:
  file.managed:
    - name: /etc/gtk-2.0/gtkrc
    - source: salt://common-templates/theme/gtkrc-2.0
    - user: root
    - group: root
    - mode: 644
    - template: jinja

{{ slsdotpath }}_mkdir_etc_gtk3.0:
  file.directory:
    - name: /etc/gtk-3.0
    - makedirs: True
    - user: root
    - group: root

{{ slsdotpath }}_copy_gtk3_config:
  file.managed:
    - name: /etc/gtk-3.0/settings.ini
    - source: salt://common-templates/theme/gtkrc-3.0
    - user: root
    - group: root
    - mode: 644
    - template: jinja

{{ slsdotpath }}_copy_gtk3_css_config:
  file.managed:
    - name: /etc/gtk-3.0/gtk.css
    - source: salt://common-templates/theme/gtk.css
    - user: root
    - group: root
    - mode: 644
