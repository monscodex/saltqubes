include:
  - common-templates.flatpak

{{ slspath }}_install_fractal_flatpak:
  cmd.run:
    - name: flatpak install -y flathub org.gnome.Fractal
    - env:
      - HTTPS_PROXY: http://localhost:8082
