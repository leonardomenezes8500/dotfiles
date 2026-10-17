# dotfiles: rules for Claude

**Public repo**: above all, never push sensitive information to GitHub. Claude runs stow; the user just asks ("add X's config to dotfiles", "set up a new machine").

## Layout
- Each top-level dir is a stow package mirroring `~` (e.g. `nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`).
- `.stowrc` sets `--target=~ --no-folding`. Always run `stow` from the repo root.
- `--no-folding` is required: without it stow links whole dirs and plugins/caches (tpm, etc.) end up inside the repo.

## Commands
- Dry run first: `stow -n -v <pkg>`
- Link: `stow -v <pkg>` · Relink after adding a file: `stow -R -v <pkg>` · Unlink: `stow -D -v <pkg>`
- Check: `ls -la ~/<file>` should point into the repo.

## Adding a config
1. Read the whole file and strip anything sensitive or machine-specific (see below).
2. Create it at the mirrored path in the repo, delete the original (git is the backup), then `stow -v <pkg>`.
3. Never use `--adopt` (it overwrites the repo with the home file, unreviewed).
4. Keep the README minimal: only update the package list in the `stow ...` line.

## Never in the repo
- Tokens, keys, passwords, `~/.ssh/*` (including `config`: hosts/IPs), `~/.config/gh/hosts.yml`, shell history, `.claude.json`.
- Machine-specific stuff (paths, tmux sessions, hosts) → `~/.bashrc.local`.
- Project env vars → direnv: `.envrc` loads them, values live in `.env` (blocked by the global ignore).
- Name and email in the git config are fine (already public in commits).

## Consistency
- Everything in English: comments, commit messages, docs.
- Before every commit: `git diff --cached` + `git grep -nIiE '(token|secret|passw|api[_-]?key|BEGIN .*PRIVATE|gh[pousr]_|sk-)'` and review every hit.
