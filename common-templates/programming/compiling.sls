{{ slsdotpath }}_install_compiling_software:
  pkg.installed:
    - pkgs:
      - ninja-build
      - gettext
      - cmake
      - libtool
      - automake
{% if grains['os_family'] == 'RedHat' %}
      - gcc
      - make
      - glibc-gconv-extra
      - autoconf
      - gcc-c++
      - libevent-devel
{% elif grains['os_family'] == 'RedHat' %}
      - build-essential
      - autotools-dev
      - bsdmainutils
      - libevent-dev
{% endif %}
