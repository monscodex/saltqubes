include:
  - {{ slsdotpath }}.pre-install-nothing

common_install:
  pkg.installed:
    - pkgs:
      - pciutils
      - psmisc
      - zenity
      - curl
      - btop
      - man-db
      # salt
      - file
      # clipboard
      - xclip
      # pagers
      - less
      - qubes-core-agent-thunar
{% if grains['os_family'] == 'Debian' %}
      - x11-utils
      - wget
      - xz-utils
{% elif grains['os_family'] == 'RedHat' %}
      - xkill
      - wget2
      - xz
{% endif %}
    - skip_suggestions: True
    - install_recommends: False
    - order: 1
