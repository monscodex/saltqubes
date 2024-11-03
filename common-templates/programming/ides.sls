{{ slsdotpath }}_install_openscad:
  pkg.installed:
    - pkgs:
        - openscad

include:
  - common-templates.flatpak

{{ slsdotpath }}_install_vscodium_flatpak:
  cmd.run:
    - name: flatpak install -y flathub com.vscodium.codium
    - env:
      - HTTPS_PROXY: http://localhost:8082
