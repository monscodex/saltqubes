# After writing a script for powermanagement for xen (intended on laptops)
# Integrate it when plugging and unplugging the laptop to power
# Guide on udev rules: https://wiki.archlinux.org/title/Udev

{% set script_target_path = "/opt/xen-powermanagement-tool" %}

{{ slsdotpath }}_copy_xen_powermanagement_script:
  file.managed:
    - name: {{ script_target_path }}
    - source: salt://{{ slspath }}/files/xen-powermanagement-tool
    - user: root
    - group: root
    - mode: 554
    - required_in:
      - file: {{ slsdotpath }}_copy_powermanagement_udev_rule


{{ slsdotpath }}_copy_powermanagement_udev_rule:
  file.managed:
    - name: /etc/udev/rules.d/powersave.rules
    - user: root
    - group: root
    - mode: 444
    - contents:
      - SUBSYSTEM=="power_supply", ATTRS{status}=="Charging", RUN+="/usr/bin/systemd-run --machine=adminabs@.host {{ script_target_path }}"
      - SUBSYSTEM=="power_supply", ATTRS{status}=="Discharging", RUN+="/usr/bin/systemd-run --machine=adminabs@.host {{ script_target_path }} battery"
