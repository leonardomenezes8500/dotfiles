# dotfiles: rules for Claude

**Public repo**: above all, never push sensitive information to GitHub.
The user just asks; Claude does the work. "install", "setup", "set up my machine" means: dotfiles + programs + skills, i.e. run `./install.sh` (re-runnable).

## Layout
- `install.sh`: the whole setup. Lists in it: `PKGS` (stow packages), `PLUGINS` (Claude marketplaces); uv tools, npm globals and skills are plain lines.
- `pacman.txt`: explicit pacman packages. Refresh with `pacman -Qqe | grep -vx base > pacman.txt`.
- Every top-level dir is a stow package mirroring `~`. `.stowrc` sets `--target=~ --no-folding` (required, or plugins/caches land in the repo). Run stow from the repo root.

## Changes
- New config: read it all, strip secrets/machine-only bits, put it at the mirrored path, delete the original (git is the backup), `stow -v <pkg>`. Never `--adopt`.
- New program/tool/skill: add its line to `install.sh` (or `pacman.txt`), keep each step idempotent.
- New stow package: add it to `PKGS`.

## Never in the repo
- Tokens, keys, passwords, `~/.ssh/*` (incl. `config`), `~/.config/gh/hosts.yml`, shell history, `~/.claude.json`, `~/.claude/CLAUDE.md` (has server details), the paid motion-video-director skill.
- Machine-only stuff → `~/.bashrc.local`. Project env vars → direnv (`.env`, globally ignored).
- Name and email in the git config are fine.

## Consistency
- Everything in English: comments, commit messages, docs. README stays minimal.
- Before every commit: `git diff --cached` + `git grep -nIiE '(token|secret|passw|api[_-]?key|BEGIN .*PRIVATE|gh[pousr]_|sk-)'`, review every hit.
