{{ slsdotpath }}_update:
  pkg.uptodate:
    - refresh: True

{{ slsdotpath }}_install:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-thunar
      - qubes-app-shutdown-idle
      - keepassxc
    - skip_suggestions: True
    - install_recommends: False

# Absolute minimal. No hooks (no config, no mimeapps. nothing.)
