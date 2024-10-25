include:
  - common-templates.flatpak
  - {{ slsdotpath }}.musescore

{{ slspath }}_install_editing_flatpaks:
  cmd.run:
    - name: https_proxy=http://localhost:8082 flatpak install -y flathub org.onlyoffice.desktopeditors org.audacityteam.Audacity net.giuspen.cherrytree md.obsidian.Obsidian io.github.qnapi com.github.robertsanseries.ciano fr.handbrake.ghb garden.jamie.Morphosis

{{ slspath }}_install_editing_official_packages:
  pkg.installed:
    - pkgs:
      - digikam
      - gimp
      - rawtherapee
      - krita
      - darktable
{% if grains['os_family'] == 'RedHat' %}
      - ffmpeg-free
      - openshot
{% elif grains['os_family'] == 'Debian' %}
      - ffmpeg
      - openshot-qt
{% endif %}
