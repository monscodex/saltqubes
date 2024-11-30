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
  - common-templates.dunst
  - common-templates.thunar-thumbnails
  - {{ slsdotpath }}.files.signal-desktop
  - common-templates.hooks.post-install-nothing
