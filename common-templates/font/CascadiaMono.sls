{{ slsdotpath }}_download_caskaydia_cove_regular:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082 -o /tmp/caskaydiacove.ttf -- "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/CascadiaCode/Regular/CaskaydiaCoveNerdFontMono-Regular.ttf?raw=true"

{{ slsdotpath }}_download_caskaydia_cove_bold:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082 -o /tmp/caskaydiacovebold.ttf -- "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/CascadiaCode/Bold/CaskaydiaCoveNerdFontMono-Bold.ttf?raw=true"

{{ slsdotpath }}_copy_caskaydia_cove_regular:
  file.managed:
    - name: /usr/share/fonts/CaskaydiaCoveNerdFontMono-Regular.ttf
    - source: /tmp/caskaydiacove.ttf
    - user: root
    - group: root
    - mode: 444

{{ slsdotpath }}_clean_caskaydia_cove_regular:
  file.absent:
    - name: /tmp/caskaydiacove.ttf

{{ slsdotpath }}_copy_caskaydia_cove_bold:
  file.managed:
    - name: /usr/share/fonts/CaskaydiaCoveNerdFontMono-Bold.ttf
    - source: /tmp/caskaydiacovebold.ttf
    - user: root
    - group: root
    - mode: 444

{{ slsdotpath }}_clean_caskaydia_cove_bold:
  file.absent:
    - name: /tmp/caskaydiacovebold.ttf
