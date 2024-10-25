{% if grains['os_family'] == 'Debian' %}


{{ slsdotpath }}_install_extrepo:
  pkg.installed:
    - name: extrepo

{{ slsdotpath }}_add_repo:
  cmd.run:
    - name: https_proxy=http://127.0.0.1:8082 extrepo enable librewolf
    - runas: root


{% elif grains['os_family'] == 'RedHat' %}


{{ slsdotpath }}_copy_gpg_key:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-librewolf
    - source: salt://{{ slspath }}/librewolf.gpg

{{ slsdotpath }}_copy_repo:
  file.managed:
    - name: /etc/yum.repos.d/librewolf.repo
    - source: salt://{{ slspath }}/librewolf.repo


#{{ slsdotpath }}
#- name: dnf config-manager --add-repo https://rpm.librewolf.net/librewolf-repo.repo


{% endif %}


{{ slsdotpath }}_refresh_packages:
  pkg.uptodate:
    - refresh: True

{{ slsdotpath }}_install:
  pkg.installed:
    - name: librewolf
