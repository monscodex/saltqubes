{% from slspath ~ '/template-name.jinja' import base_template, create_new_template, template_name %}


{% if create_new_template %}

{{ slsdotpath }}_remove_new_template_if_needed:
  qvm.absent:
    - name: {{ template_name }}

{% endif %}


{{ slsdotpath }}_precursor:
  qvm.template_installed:
    - name: {{ base_template }}

{{ slsdotpath }}_qvm-clone:
  qvm.clone:
    - name: {{ template_name }}
    - source: {{ base_template }}

{{ slsdotpath }}_menu:
  qvm.features:
    - name: {{ template_name }}
    - set:
      - menu-items: "debian-xterm.desktop"
      - default-menu-items: "signal-desktop.desktop"
