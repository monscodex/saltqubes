{% if not salt['file.file_exists']('/home/user/.nix-profile/bin/nix-env') %}


include:
  - common-appvms.nix


{% endif %}



{% if not salt["file.file_exists"]('/home/user/.nix-profile/bin/lvim') %}


{{ slsdotpath }}_mkdir_config_nixpkgs:
  file.directory:
    - name: /home/user/.config/nixpkgs
    - user: user
    - group: user
    - dir_mode: 755

{{ slsdotpath }}_copy_nixpkgs_config:
  file.managed:
    - name: /home/user/.config/nixpkgs/config.nix
    - source: salt://{{ slspath }}/files/config.nix
    - user: root
    - group: root
    - mode: 444

{{ slsdotpath }}_install_nixpkgs_from_config:
  cmd.run:
    - name: nix-env -iA nixpkgs.developmentPackages
    - runas: user

{% include slspath ~ "/lunarvim.sls" %}

{% endif %}
