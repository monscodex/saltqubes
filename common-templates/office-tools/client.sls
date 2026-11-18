include:
  - common-templates.flatpak

{{ slspath }}_install_client_flatpaks:
  cmd.run:
    - name: flatpak install -y flathub io.freetubeapp.FreeTube com.github.KRTirtho.Spotube
    - env:
      - HTTPS_PROXY: http://localhost:8082

{{ slspath }}_install_client_official_packages:
  pkg.installed:
    - pkgs:
      - evince
      - calibre
      - clementine
      - gthumb
      - mpv
      - celluloid
      - yt-dlp
      - youtube-dl
{% if grains['os_family'] == 'RedHat' %}
      - pandoc-common
      - ghc-pandoc
      - vlc
{% elif grains['os_family'] == 'Debian' %}
      - pandoc
      - vlc-bin
{% endif %}
