include:
  - common-templates.command-line.neovim
  - common-templates.command-line.difftastic
  - common-templates.command-line.dust
  - common-templates.command-line.ranger
  - common-templates.command-line.starship
  - common-templates.command-line.terminal
  - common-templates.command-line.fastfetch
  - common-templates.command-line.fish


command-line-tools_install:
  pkg.installed:
    - pkgs:
      - eza
      - bat
      - fzf
      - zoxide
      - fd-find
      - ripgrep
      - trash-cli
      - man-db
      - xsel
      - hyperfine
      - python3-ipython
{% if grains['os_family'] == 'RedHat' %}
      - procps-ng # Provides watch, ps, top
{% endif %}
