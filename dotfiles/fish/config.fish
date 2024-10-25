# Do not alias or force running some commands
# if we are running a command (especially with saltstack)
if not status is-interactive
    return 0
end

### BINDINGS ###

# Vim jkhl bindings
bind \ch backward-char
bind \cl forward-char

bind \ej history-search-forward
bind \ek history-search-backward
bind \eh backward-bigword
bind \el forward-bigword

### END BINDINGS ##

# First line removes the path; second line sets it.  Without the first line,
# your path gets massive and fish becomes very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.local/bin $HOME/Applications $fish_user_paths

set fish_greeting                                 # Supresses fish's intro message

### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
set fish_color_normal brcyan
set fish_color_autosuggestion '#7d7d7d'
set fish_color_command brcyan
set fish_color_error '#ff6c6b'
set fish_color_param brcyan

### ALIASES ###

alias ..='cd ..'
alias ...='cd ../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Custom ls/eza aliases
if command -q exa
  alias eza='exa'
end

if command -q eza || functions -q eza
  alias ls="eza --color=always --icons --group-directories-first"
  alias tree="ls -aT"
else
  alias ls="ls --color=always --group-directories-first --human-readable"
end

alias ll="ls -al"
alias lt="tree"


# Grep
alias grep='grep --color=auto --ignore-case'
alias egrep='egrep --color=auto --ignore-case'
alias fgrep='fgrep --color=auto --ignore-case':vs

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'

if command -q trash-put
  alias rmforreal='/usr/bin/rm -i'
  alias rm='trash-put'
end

alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

# youtube-dl

if command -q yt-dlp
  alias yta-aac="yt-dlp --extract-audio --audio-format aac "
  alias yta-best="yt-dlp --extract-audio --audio-format best "
  alias yta-flac="yt-dlp --extract-audio --audio-format flac "
  alias yta-m4a="yt-dlp --extract-audio --audio-format m4a "
  alias yta-mp3="yt-dlp --extract-audio --audio-format mp3 "
  alias yta-opus="yt-dlp --extract-audio --audio-format opus "
  alias yta-vorbis="yt-dlp --extract-audio --audio-format vorbis "
  alias yta-wav="yt-dlp --extract-audio --audio-format wav "
  alias ytv-best="yt-dlp -f bestvideo+bestaudio "
end

# the terminal rickroll
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'



if command -q bat
  alias cat='bat'
else if command -q batcat
  alias bat='batcat'
  alias cat='batcat'
end

if command -q fdfind
  alias fd='fdfind'
end

if command -q dust
  alias du='dust'
end

if command -q difft
  set -x GIT_EXTERNAL_DIFF "difft"
  alias diff='difft'
end


# Working with salt in dom0. --force-color is called UNSAFE by the manpage
if command -q qubesctl
    alias qubesctl='qubesctl --show-output --force-color'
end


# neovim commands
# IMPORTANT: screen fixes bad scrolling with multiple panes
if command -q nvim
    set -x EDITOR "/usr/bin/env TERM=screen /usr/bin/nvim -u /etc/nvim/init.lua"
    set -x MANPAGER "/usr/bin/env TERM=screen /usr/bin/nvim -u /etc/nvim/init.lua +Man!"

    alias nvim="/usr/bin/env TERM=screen /usr/bin/nvim -u /etc/nvim/init.lua"
    alias vim="nvim"
end



if command -q ranger
  # quit ranger and cd to ranger's PWD
  function ranger --wraps ranger --description 'ranger cd where you quit'
    set RANGER_DIR $HOME/.cache/.rangerdir(date +%s%N)

    # Look, fish! No recursion!!! ^^
    /usr/bin/env TERM=xterm-256color RANGER_DIR=$RANGER_DIR /usr/bin/ranger --choosedir=$RANGER_DIR

    cd (cat $RANGER_DIR)

    rm -f $RANGER_DIR
  end
end



### SETTING THE STARSHIP PROMPT ###
if command -q starship
  set -x STARSHIP_CONFIG /etc/starship.toml
  starship init fish | source
end


# :man-flexing-with-sunglasses:
if command -q fastfetch
  fastfetch

  alias neofetch='fastfetch'
end
