{% if grains['os_family'] == 'Debian' %}
    {% set protonvpnPackage = ({
        "url": "https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3-3_all.deb",
        "filename": "protonvpn.deb",
        "verify_hash": true,
        "sha256hash": "de7ef83a663049b5244736d3eabaacec003eb294a4d6024a8fbe0394f22cc4e5",
        "pkgnames": ["proton-vpn-gnome-desktop"]
    }) %}
{% elif grains['os_family'] == 'RedHat' %}
    {% set protonvpnPackage = ({
        "url": "https://repo.protonvpn.com/fedora-" ~ grains['osrelease'] ~ "-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.1-2.noarch.rpm",
        "filename": "protonvpn.rpm",
        "verify_hash": false,
        "pkgnames": ["proton-vpn-gnome-desktop"]
    }) %}
{% endif %}



{{ slsdotpath }}_download_protonvpn_package:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082 '{{ protonvpnPackage["url"] }}' -o  /tmp/{{ protonvpnPackage["filename"] }}
    - shell: /usr/bin/bash



{% if protonvpnPackage["verify_hash"] %}

{{ slsdotpath }}_copy_verified_proton_package:
  file.managed:
    - name: /tmp/hashok-{{ protonvpnPackage["filename"] }}
    - source: /tmp/{{ protonvpnPackage["filename"] }}
    - source_hash: {{ protonvpnPackage["sha256hash"] }}

{% else %}

{{ slsdotpath }}_rename_unverified_proton_package:
  file.rename:
    - name: /tmp/hashok-{{ protonvpnPackage["filename"] }}
    - source: /tmp/{{ protonvpnPackage["filename"] }}

{% endif %}




{{ slsdotpath }}_install_protonvpn_stable_release:
  pkg.installed:
    - sources:
      - protonvpn-stable-release: /tmp/hashok-{{ protonvpnPackage["filename"] }}

{{ slsdotpath }}_install_protonvpn_package:
  pkg.installed:
    - pkgs:
      {{ protonvpnPackage["pkgnames"] | yaml(false) | indent(6) }}
