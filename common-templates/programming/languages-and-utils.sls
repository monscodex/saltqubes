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
{% elif grains['os_family'] == 'Debian' %}
      - python3-dev
{% endif %}

other-languages_install:
  pkg.installed:
    - pkgs:
      - cargo
      - luarocks
      - ruby
      - php
      - golang
      - nodejs
{% if grains['os_family'] == 'RedHat' %}
      - java-latest-openjdk
      - nodejs-npm
{% elif grains['os_family'] == 'Debian' %}
      - default-jdk
      - npm
{% endif %}

developper_utils_install:
  pkg.installed:
    - pkgs:
      - git
      - gnupg2
