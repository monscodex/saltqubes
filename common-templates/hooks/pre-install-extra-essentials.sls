include:
  - {{ slsdotpath }}.pre-install-nothing

common_install:
  pkg.installed:
    - pkgs:
      - pciutils
      - psmisc
      - zenity
      - curl
{% if grains['os_family'] == 'Debian' %}
      - x11-utils
      - wget
{% elif grains['os_family'] == 'RedHat' %}
      - xkill
      - wget2
{% endif %}
      - bpytop
      - man-db
      # File systems
      - exfatprogs
      - e2fsprogs
      - btrfs-progs
      # salt
      - file
      # clipboard
      - xclip
      # pagers
      - less
    - skip_suggestions: True
    - install_recommends: False
    - order: 1
