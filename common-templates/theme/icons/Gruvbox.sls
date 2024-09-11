{% if not salt['file.directory_exists' ]('/usr/share/icons/Gruvbox') %}


{{ slsdotpath }}_download_gruvbox_icons_archive:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082/ https://github.com/jmattheis/gruvbox-dark-icons-gtk/archive/refs/heads/master.zip -o /tmp/gruvbox-icons.zip

{{ slsdotpath }}_extract_gruvbox_icons_archive:
  cmd.run:
    - name: unzip -q /tmp/gruvbox-icons.zip -d /usr/share/icons

{{ slsdotpath }}_copy_gruvbox_icons_archive:
  cmd.run:
    - name: mv /usr/share/icons/gruvbox-dark-icons-gtk-master /usr/share/icons/Gruvbox

{{ slsdotpath }}_clean_gruvbox_icons_archive:
  file.absent:
    - name: /tmp/gruvbox-icons.zip


{% endif %}
