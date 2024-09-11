include:
  - {{ slsdotpath }}.pre-install-nothing

common_install:
  pkg.installed:
    - pkgs:
      - pciutils
      - psmisc
      - wget
      - zenity
{% if grains['os_family'] == 'Debian' %}
      - x11-utils
      - curl
{% elif grains['os_family'] == 'RedHat' %}
      - xkill
      - curl-minimal
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
