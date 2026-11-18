{% if not grains['os_family'] == 'RedHat' %}


{{ slsdotpath }}_alert_cannot_install_docker:
  test.fail_without_changes:
    - name: "Cannot install docker on other OSes than FEDORA"
    - failhard: True


{% else %}


{{ slsdotpath }}_install_docker:
  pkg.installed:
    - pkgs:
      - containerd
      - docker-cli
      - docker-compose
      - docker-compose-switch


{% endif %}
