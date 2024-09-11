{% if not salt['file.directory_exists' ]('/usr/share/themes/Tokyo-Night') %}


{{ slsdotpath }}_download_tokyonight_theme_archive:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082/ https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme/archive/refs/heads/master.zip -o /tmp/tokyo-night.zip

{{ slsdotpath }}_remove_previous_tokyonight_theme:
  file.absent:
    - name: /usr/share/themes/Tokyo-Night

{{ slsdotpath }}_extract_tokyonight_theme_archive:
  cmd.run:
    - name: unzip -q /tmp/tokyo-night.zip "Tokyo-Night-GTK-Theme-master/themes/Tokyonight-Dark-B/*" -d /usr/share/themes

{{ slsdotpath }}_copy_tokyonight_theme:
  cmd.run:
    - name: mv /usr/share/themes/Tokyo-Night-GTK-Theme-master/themes/Tokyonight-Dark-B /usr/share/themes/Tokyo-Night

{{ slsdotpath }}_clean_tokyonight_theme:
  file.absent:
    - name: /usr/share/themes/Tokyo-Night-GTK-Theme-master

{{ slsdotpath }}_clean_tokyonight_theme_archive:
  file.absent:
    - name: /tmp/tokyo-night.zip


{% endif %}
