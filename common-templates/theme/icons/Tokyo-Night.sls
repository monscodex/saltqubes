{{ slsdotpath }}_download_tokyonight_icons_archive:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082/ https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme/archive/refs/heads/master.zip -o /tmp/tokyo-night-icons.zip

{{ slsdotpath }}_remove_previous_tokyonight_icons:
  file.absent:
    - name: /usr/share/icons/Tokyo-Night

{{ slsdotpath }}_extract_tokyonight_icons_archive:
  cmd.run:
    - name: unzip -q /tmp/tokyo-night-icons.zip "Tokyo-Night-GTK-Theme-master/icons/Tokyonight-Dark/*" -d /usr/share/icons

{{ slsdotpath }}_copy_tokyonight_icons_archive:
  cmd.run:
    - name: mv /usr/share/icons/Tokyo-Night-GTK-Theme-master/icons/Tokyonight-Dark/ /usr/share/icons/Tokyo-Night

{{ slsdotpath }}_clean_tokyonight_icons_archive:
  file.absent:
    - name: /tmp/tokyo-night-icons.zip
