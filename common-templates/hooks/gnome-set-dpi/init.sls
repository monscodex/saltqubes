{% set is_gnome_running = salt.cmd.shell("ps -ef | grep [g]nome-session | wc -l") == "1" %}

{% if is_gnome_running %}


{{ slsdotpath }}_create_dpi_dconf_configuration_file:
  file.managed:
    - name: /etc/dconf/db/local.d/dpi
    - source: salt://{{ slspath }}/dconf-dpi
    - user: root
    - group: root
    - mode: 444

{{ slsdotpath }}_update_dconf_settings:
  cmd.run:
    - name: dconf update


{% endif %}
