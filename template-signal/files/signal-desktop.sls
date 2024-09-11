{{ slsdotpath }}_copy_signal_keyring:
  file.managed:
    - name: /usr/share/keyrings/signal-desktop-keyring.gpg
    - source: salt://{{ slspath }}/signal-desktop.gpg

{{ slsdotpath }}_add-repo:
  pkgrepo.managed:
    - name: deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main
    - file: /etc/apt/sources.list.d/signal-xenial.list
    - gpgkey: /usr/share/keyrings/signal-desktop-keyring.gpg
    - gpgcheck: 1

{{ slsdotpath }}_install_signal:
  pkg.installed:
    - name: signal-desktop
    - skip_suggestions: True
    - install_recommends: False
