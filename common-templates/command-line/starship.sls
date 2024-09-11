{{ slsdotpath }}_download_starship_archive:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082/ https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz -o /tmp/starship.tar.gz

{{ slsdotpath }}_extract_starship_archive:
  cmd.run:
    - name: tar xf /tmp/starship.tar.gz -C /tmp


{{ slsdotpath }}_copy_starship_binary:
  file.managed:
    - name: /usr/bin/starship
    - source: /tmp/starship
    - user: root
    - group: root
    - mode: 755

{{ slsdotpath }}_copy_starship_config:
  file.managed:
    - name: /etc/starship.toml
    - source: salt://dotfiles/starship.toml
    - user: user
    - group: user


{{ slsdotpath }}_remove_starship_archive:
  file.absent:
    - name: /tmp/starship.tar.gz

{{ slsdotpath }}_remove_starship_binary:
  file.absent:
    - name: /tmp/starship
