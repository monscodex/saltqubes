{% if grains['os_family'] == 'Debian' %}
    {% set weztermPackage = ({
        "url": "https://github.com/wez/wezterm/releases/download/20230712-072601-f4abf8fd/wezterm-20230712-072601-f4abf8fd.Ubuntu22.04.deb",
        "filename": "wezterm.deb",
        "sha256hash": "401624fe364e0f63f225077c63e9ae71ce5684478626eea099c5bcf89df93720"
    }) %}
{% elif grains['os_family'] == 'RedHat' %}
    {% set weztermPackage = ({
        "url": "https://github.com/wez/wezterm/releases/download/20230712-072601-f4abf8fd/wezterm-20230712_072601_f4abf8fd-1.fedora38.x86_64.rpm",
        "filename": "wezterm.rpm",
        "sha256hash": "a18d7ad3c9df08dcb3ce770ce6f01453207874b9743a0a46bf340bca409179f5"
    }) %}
{% endif %}


{{ slsdotpath }}_download_wezterm_package:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082 {{ weztermPackage["url"] }} -o  /tmp/{{ weztermPackage["filename"] }}

{{ slsdotpath }}_verify_wezterm_package:
  file.managed:
    - name: /tmp/hashok-{{ weztermPackage["filename"] }}
    - source: /tmp/{{ weztermPackage["filename"] }}
    - source_hash: {{ weztermPackage["sha256hash"] }}

{{ slsdotpath }}_install_wezterm_package:
  pkg.installed:
    - name: wezterm
    - sources:
      - wezterm: /tmp/hashok-{{ weztermPackage["filename"] }}

{{ slsdotpath }}_create_directory:
  file.directory:
    - name: /etc/wezterm
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 444

{{ slsdotpath }}_copy_wezterm_config:
  file.managed:
    - name: /etc/wezterm/wezterm.lua
    - source: salt://dotfiles/wezterm.lua
    - user: root
    - group: root
    - mode: 444

{{ slsdotpath }}_create_wezterm_configuration_script:
  file.managed:
    - name: /etc/profile.d/weztermconfigdirectory.sh
    - user: root
    - group: root
    - mode: 555
    - contents: export WEZTERM_CONFIG_FILE=/etc/wezterm/wezterm.lua
