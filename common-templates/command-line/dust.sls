{{ slsdotpath }}_download_dust_archive:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082/ "https://github.com/bootandy/dust/releases/download/v0.8.6/dust-v0.8.6-x86_64-unknown-linux-gnu.tar.gz" -o /tmp/dust.tar.gz

{{ slsdotpath }}_extract_dust_archive:
  cmd.run:
    - name: tar xf /tmp/dust.tar.gz -C /tmp

{{ slsdotpath }}_copy_dust_binary:
  file.managed:
    - name: /usr/bin/dust
    - source: /tmp/dust-v0.8.6-x86_64-unknown-linux-gnu/dust
    - user: root
    - group: root
    - mode: 755

{{ slsdotpath }}_clean_dust_archive:
  file.absent:
    - name: /tmp/dust.tar.gz

{{ slsdotpath }}_clean_dust_binary:
  file.absent:
    - name: /tmp/dust-v0.8.6-x86_64-unknown-linux-gnu
