{{ slsdotpath }}_install_net_utils:
  pkg.installed:
    - pkgs:
      - wget
      - curl
      - whois
      - telnet
{% if grains['os_family'] == 'Debian' %}
      - iputils-ping
      - iputils-tracepath
      - dnsutils
      - ncat
{% elif grains['os_family'] == 'RedHat' %}
      - iputils
      - bind-utils
      - nmap-ncat
{% endif %}
      - tcpdump
      - iftop
