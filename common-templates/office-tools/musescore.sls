{% if grains['os_family'] == 'RedHat' %}


{{ slspath }}_install_musescore_fedora_package:
  pkg.installed:
    - pkgs:
      - musescore


{% elif grains['os_family'] == 'Debian' %}


{{ slspath }}_install_musescore_debian_fonts:
  pkg.installed:
    - pkgs:
      - musescore-general-soundfont-small

{{ slspath }}_install_musescore_debian_package:
  pkg.installed:
    - pkgs:
      - musescore3


{% endif %}
