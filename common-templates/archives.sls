archives_install:
  pkg.installed:
    - pkgs:
      - zip
      - unzip
      - ark
      - thunar-archive-plugin
{% if grains['os_family'] == 'Debian' %}
      - unrar-free
      - p7zip
{% elif grains['os_family'] == 'RedHat' %}
      - unrar
      - 7zip-standalone-all
{% endif %}
