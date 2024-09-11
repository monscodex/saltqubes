{% set template_name = 'debian-12-minimal' %}

{{ slsdotpath }}_precursor:
  qvm.template_installed:
    - name: {{ template_name }}

{{ slsdotpath }}_qvm-clone:
  qvm.clone:
    - name: {{ slsdotpath }}
    - source: {{ template_name }}

{{ slsdotpath }}_menu:
  qvm.features:
    - name: {{ slsdotpath }}
    - set:
      - menu-items: "debian-xterm.desktop"
      - default-menu-items: "signal-desktop.desktop"
