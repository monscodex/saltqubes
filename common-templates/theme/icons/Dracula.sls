{% if not salt['file.directory_exists' ]('/usr/share/icons/Dracula') %}


{{ slsdotpath }}_download_dracula_icons_archive:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082/ https://github.com/dracula/gtk/files/5214870/Dracula.zip -o /tmp/dracula.zip

{{ slsdotpath }}_copy_dracula_icons_icons:
  cmd.run:
    - name: unzip -q /tmp/dracula.zip -d /usr/share/icons/

{{ slsdotpath }}_clean_dracula_icons:
  file.absent:
    - name: /tmp/dracula.zip


{% endif %}
