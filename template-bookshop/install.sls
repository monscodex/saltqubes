{{ slsdotpath }}_update:
  pkg.uptodate:
    - refresh: True

{{ slsdotpath }}_install:
  pkg.installed:
    - pkgs:
      - qubes-core-agent-networking
      - qubes-pdf-converter
      - qubes-img-converter
      - transmission-gtk
      - qubes-core-agent-thunar
      - qubes-app-shutdown-idle
      - pulseaudio-qubes
      - qubes-audio-daemon
      - qubes-usb-proxy
    - skip_suggestions: True
    - install_recommends: False

include:
  - common-templates.hooks.pre-install-extra-essentials
  - common-templates.browser.librewolf
  - common-templates.browser.brave
  - common-templates.dunst
  - common-templates.hooks.post-install-nothing
