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

# magodownload takes links unquoted: an unquoted & would send it to the background and freeze the menu.
# The alias turns the rest of the line into a comment; the function reads the raw line from history.
# shortcut: a line starting with a space is not saved (ignorespace), so it reads the previous one; quote links then.
alias magodownload='_magodownload #'
_magodownload() {
  local n line; local -a args
  read -r n line < <(HISTTIMEFORMAT= history 1)
  [[ $line == magodownload* ]] || { echo "magodownload: could not read the line, quote the link"; return 1; }
  read -ra args <<< "${line#magodownload}"
  args=("${args[@]#[\'\"]}"); args=("${args[@]%[\'\"]}")   # quotes still work
  command magodownload "${args[@]}"
}

GREEN="\[$(tput setaf 2)\]"
RESET="\[$(tput sgr0)\]"
PS1="${GREEN}[\u@\h \W]\$${RESET} "

export EDITOR='nvim'
export HISTCONTROL="erasedups:ignorespace"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export GHIDRA_INSTALL_DIR='/opt/ghidra'
export REA_JADX_MCP_JAR="$HOME/tools/jadx-headless-mcp/jadx-headless-mcp-0.7.1-all.jar" # version pinned by rea-agents

shopt -s autocd
set -o noclobber
shopt -s checkwinsize

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# direnv: load/unload each directory's .envrc
command -v direnv >/dev/null && eval "$(direnv hook bash)"

# Machine-specific stuff (not in git)
[ -f ~/.bashrc.local ] && . ~/.bashrc.local

if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
	exec tmux new-session -A -s 'main' >/dev/null 2>&1
fi
