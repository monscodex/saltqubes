{{ slsdotpath }}_download_difftastic_archive:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082/ https://github.com/Wilfred/difftastic/releases/latest/download/difft-x86_64-unknown-linux-gnu.tar.gz -o /tmp/difftastic.tar.gz

{{ slsdotpath }}_extract_difftastic_archive:
  cmd.run:
    - name: tar xf /tmp/difftastic.tar.gz -C /tmp

{{ slsdotpath }}_copy_difftastic_binary:
  file.managed:
    - name: /usr/bin/difft
    - source: /tmp/difft
    - user: root
    - group: root
    - mode: 755

{{ slsdotpath }}_clean_difftastic_extracted_files:
  file.absent:
    - name: /tmp/difftastic.tar.gz

{{ slsdotpath }}_clean_difftastic_extracted_binary:
  file.absent:
    - name: /tmp/difftastic
