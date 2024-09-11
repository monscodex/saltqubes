{% from slspath ~ '/template-name.jinja' import base_template %}

{{ slsdotpath }}_precursor:
  qvm.template_installed:
    - name: {{ base_template }}

{{ slsdotpath }}_qvm-clone:
  qvm.clone:
    - name: {{ slsdotpath }}
    - source: {{ base_template }}


{% set xterm_desktop =
  'debian-xterm.desktop'
  if 'debian' in base_template
  else 'xterm.desktop'
%}

{{ slsdotpath }}-resize-root-volume:
  cmd.run:
    - name: qvm-volume resize {{ slsdotpath }}:root 25Gi

{{ slsdotpath }}_menu:
  qvm.features:
    - name: {{ slsdotpath }}
    - set:
      - menu-items: "{{ xterm_desktop }}"
      - default-menu-items: "librewolf.desktop brave-browser.desktop {{ xterm_desktop }}"
