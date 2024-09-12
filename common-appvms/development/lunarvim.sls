{{ slsdotpath }}_clone_lunarvim_config:
  git.cloned:
    - name: https://github.com/monscodex/lvim
    - target: /home/user/.config/lvim
    - user: user

{{ slsdotpath }}_install_lunarvim_plugins:
  cmd.run:
    - name: lvim --headless "+Lazy! sync" +qa
    - runas: user

{{ slsdotpath }}_alert_lunarvim:
  test.fail_without_changes:
    - name: "Please OPEN LVIM to install Mason's LSP servers"
    - failhard: False


{{ slsdotpath }}_delete_fish_lunarvim_editor:
  cmd.run:
    - name: sed -i '/set -x EDITOR/d' /home/user/.config/fish/config.fish

{{ slsdotpath }}_append_fish_lunarvim_editor:
  file.append:
    - name: /home/user/.config/fish/config.fish
    - text: 'alias lvim="/usr/bin/env TERM=screen lvim"; set -x EDITOR "/usr/bin/env TERM=screen lvim"; set -x MANPAGER "/usr/bin/env TERM=screen lvim +Man!"'



{{ slsdotpath }}_delete_bashrc_lunarvim_editor:
  cmd.run:
    - name: sed -i '/export EDITOR/d' /home/user/.bashrc

{{ slsdotpath }}_append_bashrc_lunarvim_editor:
  file.append:
    - name: /home/user/.bashrc
    - text: 'alias lvim="/usr/bin/env TERM=screen lvim"; export EDITOR="/usr/bin/env TERM=screen lvim"; export MANPAGER="/usr/bin/env TERM=screen lvim +Man!"'
