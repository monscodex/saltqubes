{{ slsdotpath }}_install_qubes_network_manager:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-network-manager
    - skip_suggestions: True
    - install_recommends: False

{{ slsdotpath }}_copy_service_file_to_fix_network_manager:
  file.managed:
    - name: /etc/systemd/system/fix-network-manager.service
    - source: salt://{{ slspath }}/fix-network-manager.service
    - user: root
    - group: root
    - mode: 444


{{ slsdotpath }}_make_network_manager_fix_script_directory:
  file.directory:
    - name: /etc/fix-network-manager
    - user: root
    - group: root
    - mode: 777


{{ slsdotpath }}_copy_netowork_manager_fix_script:
  file.managed:
    - name: /etc/fix-network-manager/create-qubes-service-network-manager-file.sh
    - source: salt://{{ slspath }}/create-qubes-service-network-manager-file.sh
    - user: root
    - group: root
    - mode: 555

{{ slsdotpath }}_reload_systemctl:
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: /etc/systemd/system/fix-network-manager.service


{{ slsdotpath }}_enable_netowork_manager_fix:
  service.enabled:
    - name: fix-network-manager
