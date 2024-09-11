{{ slsdotpath }}_mkdir_qubes_bind_dirs.d:
  file.directory:
    - name: /rw/config/qubes-bind-dirs.d
    - makedirs: True
    - user: root
    - group: root
    - mode: 755

{{ slsdotpath }}_create_nix_qubes_bind_dirs_configuration:
  file.managed:
    - name: /rw/config/qubes-bind-dirs.d/50_user.conf
    - user: root
    - group: root
    - mode: 444
    - contents: binds+=( '/nix' )

{{ slsdotpath }}_make_directory_rw_bind-dirs_nix:
  file.directory:
    - name: /rw/bind-dirs/nix
    - user: user
    - group: user
    - mode: 755
    - recurse:
      - user
