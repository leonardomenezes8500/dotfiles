#
# ~/.bash_profile
#

export PATH="${PATH}:${HOME}/.local/bin"

[[ -f ~/.bashrc ]] && . ~/.bashrc

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
