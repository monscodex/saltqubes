{% if not salt['file.file_exists']('/home/user/.nix-profile/bin/nix-env') %}


include:
  - {{ slsdotpath }}.create-binded-directory
  - {{ slsdotpath }}.install-nix


{% endif %}
