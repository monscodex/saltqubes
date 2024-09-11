{% if not salt['file.directory_exists']('/nix') %}


{{ slsdotpath }}_alert_reboot:
  test.fail_without_changes:
    - name: "Please REBOOT the machine and RUN AGAIN"
    - failhard: True


{% endif %}


{{ slsdotpath }}_download_and_run_nix_install_script:
  cmd.run:
    - name: sh <(curl -L https://nixos.org/nix/install) --no-daemon
    - shell: /usr/bin/bash
    - runas: user


{{ slsdotpath }}_change_config_fish_permisisons:
  file.directory:
    - name: /home/user/.config/fish
    - user: user
    - group: user
    - mode: 755
    - recurse:
      - user


{{ slsdotpath }}_touch_fish_config:
  file.managed:
    - name: /home/user/.config/fish/config.fish
    - makedirs: True

{{ slsdotpath }}_delete_fish_nix_source:
  cmd.run:
    - name: sed -i '/source \/home\/user\/.nix-profile\/etc\/profile.d\/nix.fish/d' /home/user/.config/fish/config.fish

{{ slsdotpath }}_append_fish_nix_source:
  file.append:
    - name: /home/user/.config/fish/config.fish
    - text: "if test -e /home/user/.nix-profile/etc/profile.d/nix.fish; source /home/user/.nix-profile/etc/profile.d/nix.fish; end"



{{ slsdotpath }}_delete_bash_nix_source:
  cmd.run:
    - name: sed -i '/\. \/home\/user\/.nix-profile\/etc\/profile.d\/nix.sh/d' /home/user/.bashrc

{{ slsdotpath }}_append_bash_nix_source:
  file.append:
    - name: /home/user/.bashrc
    - text: "if [ -e /home/user/.nix-profile/etc/profile.d/nix.sh ]; then . /home/user/.nix-profile/etc/profile.d/nix.sh; fi"
