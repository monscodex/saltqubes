{% if not grains['os_family'] == 'RedHat' %}


{{ slsdotpath }}_alert_cannot_install_docker:
  test.fail_without_changes:
    - name: "Cannot install docker on other OSes than FEDORA"
    - failhard: True


{% else %}


{{ slsdotpath }}_add_docker_repository:
  cmd.run:
    - name: dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

{{ slsdotpath }}_update_docker_repository:
  pkg.uptodate:
    - refresh: True

{{ slsdotpath }}_install_docker:
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io
      - docker-compose-plugin

{{ slsdotpath }}_add_user_to_docker_group:
  cmd.run:
    - name: usermod -a -G docker user

{{ slsdotpath }}_add_root_to_docker_group:
  cmd.run:
    - name: usermod -a -G docker root

{{ slsdotpath }}_mkdir_etc_docker:
  file.directory:
    - name: /etc/docker
    - makedirs: True
    - user: root
    - group: root

{{ slsdotpath }}_copy_docker_daemon:
  file.managed:
    - name: /etc/docker/daemon.json
    - source: salt://common-templates/docker/daemon.json
    - user: root
    - group: root
    - mode: 444

{{ slsdotpath }}_enable_docker_service:
  cmd.run:
    - name: systemctl enable docker


{% endif %}
