{% if grains['os_family'] == 'Debian' %}


{{ slsdotpath }}_copy_gpg_key:
  file.managed:
    - name: /usr/share/keyrings/librewolf.gpg
    - source: salt://{{ slspath }}/librewolf.gpg

{{ slsdotpath }}_copy_sources_list:
  file.managed:
    - name: /etc/apt/sources.list.d/librewolf.sources
    - source: salt://{{ slspath }}/librewolf.sources
    - template: jinja


{% elif grains['os_family'] == 'RedHat' %}


{{ slsdotpath }}_add_repo:
  cmd.run:
    - name: dnf config-manager --add-repo https://rpm.librewolf.net/librewolf-repo.repo


{% endif %}


{{ slsdotpath }}_set_autoupdate:
  pkg.uptodate:
    - refresh: True

{{ slsdotpath }}_install:
  pkg.installed:
    - name: librewolf
