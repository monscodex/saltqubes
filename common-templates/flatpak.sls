{{ slsdotpath }}_install_flatpak:
  pkg.installed:
    - name: flatpak

{{ slsdotpath }}_add_flathub_repo:
  cmd.run:
    - name: https_proxy=http://localhost:8082 flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
