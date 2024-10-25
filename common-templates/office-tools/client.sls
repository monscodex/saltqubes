include:
  - common-templates.flatpak

{{ slspath }}_install_client_flatpaks:
  cmd.run:
    - name: https_proxy=http://localhost:8082 flatpak install -y flathub io.freetubeapp.FreeTube com.github.KRTirtho.Spotube

{{ slspath }}_install_client_official_packages:
  pkg.installed:
    - pkgs:
      - evince
      - calibre
      - clementine
      - gthumb
      - celluloid
      - pandoc
      - yt-dlp
      - youtube-dl
{% if grains['os_family'] == 'RedHat' %}
      - vlc
      - yt-dlp-fish-completion
{% else %}
      - vlc-bin
{% endif %}
