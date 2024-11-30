{{ slsdotpath }}_install_net_utils:
  pkg.installed:
    - pkgs:
      - curl
      - whois
      - telnet
{% if grains['os_family'] == 'Debian' %}
      - wget
      - iputils-ping
      - iputils-tracepath
      - dnsutils
      - ncat
{% elif grains['os_family'] == 'RedHat' %}
      - wget2
      - iputils
      - bind-utils
      - nmap-ncat
{% endif %}
      - tcpdump
      - iftop
