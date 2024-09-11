{% if not salt['file.directory_exists' ]('/usr/share/themes/Gruvbox') %}


{{ slsdotpath }}_download_gruvbox_theme_archive:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082/ https://github.com/jmattheis/gruvbox-dark-gtk/archive/refs/heads/master.zip -o /tmp/gruvbox.zip

{{ slsdotpath }}_delete_previous_gruvbox_theme:
  file.absent:
    - name: /usr/share/themes/Gruvbox

{{ slsdotpath }}_extract_gruvbox_theme_archive:
  cmd.run:
    - name: unzip -q /tmp/gruvbox.zip -d /usr/share/themes/

{{ slsdotpath }}_copy_gruvbox_theme:
  cmd.run:
    - name: mv /usr/share/themes/gruvbox-dark-gtk-master /usr/share/themes/Gruvbox

{{ slsdotpath }}_clean_gruvbox_theme_archive:
  file.absent:
    - name: /tmp/gruvbox.zip


{% endif %}
