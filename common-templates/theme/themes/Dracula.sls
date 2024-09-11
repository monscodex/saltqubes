{% if not salt['file.directory_exists' ]('/usr/share/themes/Dracula') %}


{{ slsdotpath }}_download_dracula_theme_archive:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082/ https://github.com/dracula/gtk/archive/master.zip -o /tmp/dracula.zip

{{ slsdotpath }}_extract_dracula_theme_archive:
  cmd.run:
    - name: unzip -q /tmp/dracula.zip -d /tmp

{{ slsdotpath }}_copy_dracula_theme_archive:
  cmd.run:
    - name: mv /tmp/gtk-master /usr/share/themes/Dracula

{{ slsdotpath }}_clean_dracula_theme_archive:
  file.absent:
    - name: /tmp/dracula.zip


{% endif %}
