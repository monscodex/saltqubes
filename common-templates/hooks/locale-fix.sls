{% if grains['os_family'] == 'Debian' %}


{{ slsdotpath }}_configure_locale:
  file.replace:
    - name: /etc/locale.gen
    - pattern: '# en_US.UTF-8 UTF-8'
    - repl: 'en_US.UTF-8 UTF-8'

{{ slsdotpath }}_generate_locale:
  cmd.run:
    - name: /usr/sbin/locale-gen
    - runas: root


{% endif %}
