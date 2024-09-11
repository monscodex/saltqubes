{{ slsdotpath }}_install_openscad:
  pkg.installed:
    - pkgs:
        - openscad

include:
  - common-templates.flatpak

{{ slsdotpath }}_install_vscodium_flatpak:
  cmd.run:
    - name: https_proxy=http://localhost:8082 flatpak install -y flathub com.vscodium.codium
