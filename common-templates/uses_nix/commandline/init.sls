{{ slsdotpath }}_install_commandline_tools_with_nix:
  module.run:
    - name: nix.install
    - pkgs:
      - nixpkgs.difftastic
    - kwargs: {attributes: True}

include:
  - .atuin
  - .nushell
  - .zellij
