{% if grains['os_family'] == 'Debian' %}
  {% set default_xresources_location =
    "/etc/X11/Xresources/x11-common"
  %}
{% elif grains['os_family'] == 'RedHat' %}
  {% set default_xresources_location =
    "/etc/X11/Xresources"
  %}
{% else %} # Idk so it does not break
  {% set default_xresources_location =
    "/etc/X11/Xresources"
  %}
{% endif %}

{{ slsdotpath }}_copy_Xresources:
  file.managed:
    - name: {{ default_xresources_location }}
    - source: salt://dotfiles/Xresources
    - user: root
    - group: root
    - mode: 444

{{ slsdotpath }}_update_Xresources_config:
  cmd.run:
    # Do not merge, we are setting this as the default values
    - name: xrdb /etc/X11/Xresources
