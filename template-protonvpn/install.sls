{{ slsdotpath }}_update:
  pkg.uptodate:
    - refresh: True

{{ slsdotpath }}_install:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
        #{% if grains['os_family'] == 'Debian' %}
        #- ntp
        #{% elif grains['os_family'] == 'RedHat' %}
        #- ntpd
        #{% endif %}
      - gnome-keyring
      - qubes-core-agent-thunar
      - qubes-app-shutdown-idle
    - skip_suggestions: True
    - install_recommends: False


include:
  - common-templates.hooks.pre-install-extra-essentials
  - common-templates.networking.network-manager
  - common-templates.networking.net-utils
  - {{ slsdotpath }}.files.protonvpn-gui
#  - common-templates.dunst # If dealing with minimal templates
  - common-templates.hooks.post-install-nothing
