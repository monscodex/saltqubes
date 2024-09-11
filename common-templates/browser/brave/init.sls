{% if grains['os_family'] == 'Debian' %}


{{ slsdotpath }}_copy_gpg_key:
  file.managed:
    - name: /usr/share/keyrings/brave-browser-archive-keyring.gpg
    - source: salt://{{ slspath }}/brave-browser-archive-keyring.gpg

{{ slsdotpath }}_accept_gpg_key:
  pkgrepo.managed:
    - humanname: Brave Browser Repository
    - name: deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main


{% elif grains['os_family'] == 'RedHat' %}


{{ slsdotpath }}_copy_asc_key:
  file.managed:
    - name: /tmp/brave-core.asc
    - source: salt://{{ slspath }}/brave-core.asc
    - user: root
    - group: root
    - mode: 444

{{ slsdotpath }}_add_repo:
  pkgrepo.managed:
    - humanname: Brave Browser
    - baseurl: https://brave-browser-rpm-release.s3.brave.com/$basearch
    - gpgkey: file:///tmp/brave-core.asc
    - gpgcheck: 1


{% endif %}


{{ slsdotpath }}_set_autoupdate:
  pkg.uptodate:
    - refresh: True

{{ slsdotpath }}_install:
  pkg.installed:
    - name: brave-browser

