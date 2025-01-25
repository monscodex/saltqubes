include:
  - {{ slsdotpath }}.editing
  - {{ slsdotpath }}.client
  - common-templates.thunar-thumbnails

{{ slspath }}_install_diverse_flatpaks:
  cmd.run:
    - name: flatpak install -y flathub io.github.alainm23.planify org.gnome.clocks io.github.Qalculate
    - env:
      - HTTPS_PROXY: http://localhost:8082
