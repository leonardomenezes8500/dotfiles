#!/bin/sh
# Set up an Arch (WSL) machine: packages, dotfiles, tools, Claude plugins and skills.
# Safe to re-run: every step skips what is already there.
set -eu
cd "$(dirname "$0")"

PKGS="bash bin git nvim tmux"
PLUGINS="DietrichGebert/ponytail blader/humanizer Leonxlnx/taste-skill"
export PATH="$HOME/.local/bin:$PATH"

step() { printf '\n==> %s\n' "$*"; }
has() { command -v "$1" >/dev/null 2>&1; }

step "pacman packages"
sudo pacman -Syu --needed --noconfirm $(cat pacman.txt)

if grep -qi microsoft /proc/version && ! grep -q 'systemd=true' /etc/wsl.conf 2>/dev/null; then
	step "wsl.conf (restart WSL afterwards: wsl --shutdown)"
	printf '[boot]\nsystemd=true\n[user]\ndefault=%s\n' "$USER" | sudo tee /etc/wsl.conf
fi

step "dotfiles"
# Files that already exist (e.g. Arch's default .bashrc) are kept as *.pre-dotfiles
for p in $PKGS; do
	(cd "$p" && find . -type f) | while read -r f; do
		t="$HOME/${f#./}"
		if [ -e "$t" ] && [ ! -L "$t" ]; then mv "$t" "$t.pre-dotfiles"; echo "kept old $t as .pre-dotfiles"; fi
	done
done
stow -v $PKGS
systemctl --user enable --now ssh-agent.socket || true # fails until WSL restarts with systemd

step "uv + python + tools"
has uv || curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
uv python install --default
uv tool install gallery-dl --with yt-dlp
uv tool install graphifyy

step "node + npm globals"
# PROFILE=/dev/null: nvm must not append to the stowed .bashrc (it already loads nvm)
[ -s "$HOME/.nvm/nvm.sh" ] || curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | PROFILE=/dev/null bash
bash -c '. "$HOME/.nvm/nvm.sh" && nvm install --lts && nvm install-latest-npm && npm install -g rea-agents @playwright/cli@latest'
has codex || bash -c '. "$HOME/.nvm/nvm.sh" && npm install -g @openai/codex'

step "skill tools (~/tools)"
# rea's jadx engine: rea pins this release and its sha256, but does not download it
J="$HOME/tools/jadx-headless-mcp/jadx-headless-mcp-0.7.1-all.jar"
if [ ! -f "$J" ]; then
	mkdir -p "${J%/*}"
	curl -fL -o "$J.part" https://github.com/1013503897/jadx-headless-mcp/releases/download/v0.7.1/jadx-headless-mcp-0.7.1-all.jar
	echo "6e5eacf500b64292bfb73c49797c1958f6ee44646e43e868039ae7feb573ff75  $J.part" | sha256sum -c -
	mv "$J.part" "$J"
fi

step "gh login"
gh auth status >/dev/null 2>&1 || gh auth login --git-protocol https --web

step "claude code + plugins + skills"
has claude || curl -fsSL https://claude.ai/install.sh | bash
for r in $PLUGINS; do
	n=${r#*/}
	claude plugin marketplace list | grep -q "❯ $n$" || claude plugin marketplace add "$r"
	claude plugin list | grep -q "❯ $n@$n$" || claude plugin install "$n@$n"
done
graphify install --platform claude
bash -c '. "$HOME/.nvm/nvm.sh" && npx -y skills add remotion-dev/skills -g -s "*" -a claude-code codex -y \
	&& npx -y skills add vercel-labs/agent-skills -g -s web-design-guidelines -a claude-code codex -y'
GHIDRA_INSTALL_DIR=/opt/ghidra REA_JADX_MCP_JAR="$J" bash -c '. "$HOME/.nvm/nvm.sh" && rea setup --yes --client claude_code --client codex'

step "done"
echo "Manual: motion-video-director (paid skill) -> ~/.claude/skills/; machine-only stuff -> ~/.bashrc.local"
