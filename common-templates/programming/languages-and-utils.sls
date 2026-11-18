python3_install:
  pkg.installed:
    - pkgs:
      - python3
      - python3-pip
      - python3-setuptools
      - python3-pytest
      - python3-virtualenv
      - python3-poetry
{% if grains['os_family'] == 'RedHat' %}
      - python3-devel
      - python3-uv
{% elif grains['os_family'] == 'Debian' %}
      - python3-dev
      # python3-uv has no equivalent in the debian repos
{% endif %}

other-languages_install:
  pkg.installed:
    - pkgs:
      - cargo
      - luarocks
      - ruby
      - php
      - golang
      - gdb
{% if grains['os_family'] == 'RedHat' %}
      - java-latest-openjdk
      - nodejs24-npm-bin
      - nodejs24
{% elif grains['os_family'] == 'Debian' %}
      - default-jdk
      - nodejs
      - npm
{% endif %}

developper_utils_install:
  pkg.installed:
    - pkgs:
      - git
      - gnupg2
