{{ slsdotpath }}_install_dunst:
  pkg.installed:
    - pkgs:
      - dunst
{% if grains['os_family'] == 'Debian' %}
      - libnotify-bin
{% elif grains['os_family'] == 'RedHat' %}
      - libnotify
{% endif %}

{{ slsdotpath }}_mkdir_etc_dunst:
  file.directory:
    - name: /etc/dunst
    - makedirs: True
    - user: root
    - group: root

{{ slsdotpath }}_copy_dunstrc_config:
  file.managed:
    - name: /etc/dunst/dunstrc
    - source: salt://dotfiles/dunst/dunstrc
    - mode: 444
    - user: root
    - group: root
