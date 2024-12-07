{% if grains['os_family'] == 'Debian' %}


{{ slsdotpath }}_copy_gpg_key:
  file.managed:
    - name: /usr/share/keyrings/mullvad-keyring.asc
    - source: salt://{{ slspath }}/mullvad-keyring.asc

{{ slsdotpath }}_copy_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/mullvad.list
    - source: salt://{{ slspath }}/mullvad.list
    - template: jinja
    - defaults:
      osarch: {{ grains['osarch'] }}
      oscodename: {{ grains['oscodename'] }}


{% elif grains['os_family'] == 'RedHat' %}


{{ slsdotpath }}_copy_gpg_key:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-mullvad
    - source: salt://{{ slspath }}/mullvad-keyring.asc

{{ slsdotpath }}_copy_repo:
  file.managed:
    - name: /etc/yum.repos.d/mullvad.repo
    - source: salt://{{ slspath }}/mullvad.repo


{% endif %}


{{ slsdotpath }}_refresh_packages:
  pkg.uptodate:
    - refresh: True

{{ slsdotpath }}_install:
  pkg.installed:
    - name: mullvad-browser
