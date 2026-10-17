# dotfiles: regras pro Claude

Repo **público**: o mais importante é nunca vazar informação sensível pro GitHub. Quem mexe no stow é o Claude; o usuário só pede ("põe a config do X no dotfiles", "instala na máquina nova").

## Estrutura
- Cada pasta do topo = pacote stow, espelhando `~` (ex.: `nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`).
- `.stowrc` já define `--target=~ --no-folding`. Sempre rodar `stow` de dentro do repo.
- `--no-folding` é obrigatório: sem ele o stow linka a pasta inteira e plugins/caches (tpm, etc.) caem dentro do repo.

## Comandos
- Ensaio antes de tudo: `stow -n -v <pacote>`
- Linkar: `stow -v <pacote>` · Relinkar após adicionar arquivo: `stow -R -v <pacote>` · Remover links: `stow -D -v <pacote>`
- Conferir: `ls -la ~/<arquivo>` deve apontar pro repo.

## Adicionar uma config nova
1. Ler o arquivo inteiro e tirar tudo sensível ou específico da máquina (ver abaixo).
2. Criar no repo no caminho espelhado, mover o original pra backup (`~/.dotfiles-backup/<data>/`), `stow -v <pacote>`.
3. Nunca usar `--adopt` (sobrescreve o repo com o arquivo da home sem revisão).
4. README fica mínimo e em inglês: só atualizar a lista de pacotes no `stow ...`.

## Nunca vai pro repo
- Tokens, chaves, senhas, `~/.ssh/*` (inclusive `config`: tem hosts/IPs), `~/.config/gh/hosts.yml`, histórico de shell, `.claude.json`.
- E-mail/nome pessoal → `~/.config/git/config.local`. Coisas desta máquina (paths, sessões tmux, hosts) → `~/.bashrc.local`.
- Env vars de projeto → direnv: `.envrc` carrega, valores no `.env` (bloqueado pelo ignore global).
- Mensagens de commit sempre em inglês.
- Antes de todo commit: `git diff --cached` + `git grep -nIiE '(token|secret|passw|api[_-]?key|BEGIN .*PRIVATE|gh[pousr]_|sk-)'` e revisar cada hit.
