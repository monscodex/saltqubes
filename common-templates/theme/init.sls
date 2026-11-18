{{ slsdotpath }}_install:
  pkg.installed:
    - pkgs:
{% if grains['os_family'] == 'Debian' %}
      - qt5-style-plugins
      - gtk2-engines-murrine
      - gnome-themes-extra-data
{% elif grains['os_family'] == 'RedHat' %}
      - qt5-qtstyleplugins
      - gtk-murrine-engine
      - adw-gtk3-theme
{% endif %}
    - skip_suggestions: True
    - install_recommends: False
    - order: 1

include:
  - common-templates.theme.themes.{{ salt['pillar.get']('theme:gtk', 'Dracula') }}
  - common-templates.theme.icons.{{ salt['pillar.get']('theme:icons', 'Dracula') }}
  - common-templates.theme.gtk
  - common-templates.theme.qt


# For the moment I don't need a fancy theme for flatpaks
# Just Dark.
{% if salt['file.file_exists']('/usr/bin/flatpak') %}

{{ slsdotpath }}_setup_flatpak_dark:
  cmd.run:
    - name: flatpak override --env=GTK_THEME=Adwaita:dark

{% endif %}
