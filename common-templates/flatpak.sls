{{ slsdotpath }}_install_flatpak:
  pkg.installed:
    - name: flatpak

{{ slsdotpath }}_add_flathub_repo:
  cmd.run:
    - name: flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    - env:
      - HTTPS_PROXY: http://localhost:8082
