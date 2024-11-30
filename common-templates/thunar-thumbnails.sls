
{{ slsdotpath }}_install_thumbnailers:
  pkg.installed:
    - pkgs:
      - tumbler
{% if grains['os_family'] == 'Debian' %}
      - libgdk-pixbuf2.0-bin
      - ffmpegthumbnailer
      - tumbler-plugins-extra
{% elif grains['os_family'] == 'RedHat' %}
      - tumbler-extras
{% endif %}


{{ slsdotpath }}_replace_xml_thumbnailer_property:
  cmd.run:
    - name: 'sed -i "s/THUNAR_THUMBNAIL_MODE_NEVER/THUNAR_THUMBNAIL_MODE_ALWAYS/g" /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/thunar.xml'
    - runas: root
