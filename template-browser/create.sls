{% from slspath ~ '/template-name.jinja' import base_template, create_new_template, create_new_template, template_name %}


{% if create_new_template %}

{{ slsdotpath }}_remove_new_template_if_needed:
  qvm.absent:
    - name: {{ template_name }}

{% endif %}


{{ slsdotpath }}_intall_base_template_if_needed:
  qvm.template_installed:
    - name: {{ base_template }}

{{ slsdotpath }}_qvm-clone:
  qvm.clone:
    - name: {{ template_name }}
    - source: {{ base_template }}

{% set xterm_desktop =
  'debian-xterm.desktop'
  if 'debian' in base_template
  else 'xterm.desktop'
%}

{{ slsdotpath }}_menu:
  qvm.features:
    - name: {{ template_name }}
    - set:
      - menu-items: "{{ xterm_desktop }}"
      - default-menu-items: "librewolf.desktop brave-browser.desktop"
