include:
  - {{ slsdotpath }}.editing
  - {{ slsdotpath }}.client

{{ slspath }}_install_diverse_flatpaks:
  cmd.run:
    - name: https_proxy=http://localhost:8082 flatpak install -y flathub io.github.alainm23.planify org.gnome.clocks
