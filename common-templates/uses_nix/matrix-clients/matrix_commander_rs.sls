{{ slsdotpath }}_install_matrix_commander_rs_with_nix:
  module.run:
    - name: nix.install
    - pkgs:
      - nixpkgs.matrix-commander-rs
    - kwargs: {attributes: True}
