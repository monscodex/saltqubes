{% if grains['os'] == 'Debian' %}


{{ slsdotpath }}_download_fastfetch_deb:
  cmd.run:
    - name: curl -LJ --proxy http://127.0.0.1:8082 https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb -o /tmp/fastfetch-linux-amd64.deb

{{ slsdotpath }}_install_fastfetch_deb:
  pkg.installed:
    - name: fastfetch
    - sources:
      - fastfetch: /tmp/fastfetch-linux-amd64.deb

{{ slsdotpath }}_clean_fastfetch_deb:
  file.absent:
    - name: /tmp/fastfetch-linux-amd64.deb

{% elif grains['os'] == 'RedHat'%}

{{ slsdotpath }}_install_fastfetch:
  pkg.installed:
    - name: fastfetch


{% endif %}
