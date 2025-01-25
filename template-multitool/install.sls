{{ slsdotpath }}_update:
  pkg.uptodate:
    - refresh: True

{{ slsdotpath }}_install:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - qubes-pdf-converter
      - qubes-img-converter
      - qubes-core-agent-thunar
      - qubes-app-shutdown-idle
      - qubes-usb-proxy
      - pulseaudio-qubes
      - qubes-audio-daemon
    - skip_suggestions: True
    - install_recommends: False

include:
  - common-templates.hooks.pre-install-extra-essentials
  - common-templates.command-line
  - common-templates.disk-mount
  - common-templates.docker
  - common-templates.programming
  - common-templates.networking.net-utils
  - common-templates.archives
  - common-templates.flatpak
  - common-templates.office-tools
  - common-templates.theme
  - common-templates.font
  - common-templates.dunst
  - common-templates.browser.brave
  - common-templates.browser.librewolf
  - common-templates.browser.mullvad-browser
  - common-templates.hooks.post-install-nothing
