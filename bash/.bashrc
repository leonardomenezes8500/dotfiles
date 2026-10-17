#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias v='nvim'
alias g='git'
alias t='tmux'
alias p='sudo pacman'

alias la='ls --color=auto -Al'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

GREEN="\[$(tput setaf 2)\]"
RESET="\[$(tput sgr0)\]"
PS1="${GREEN}[\u@\h \W]\$${RESET} "

export EDITOR='nvim'
export HISTCONTROL="erasedups:ignorespace"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

shopt -s autocd
set -o noclobber
shopt -s checkwinsize

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# direnv: carrega/descarrega o .envrc de cada pasta
command -v direnv >/dev/null && eval "$(direnv hook bash)"

# Coisas desta máquina (fora do git): paths, sessões, segredos nunca aqui
[ -f ~/.bashrc.local ] && . ~/.bashrc.local

if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
	exec tmux new-session -A -s 'main' >/dev/null 2>&1
fi
