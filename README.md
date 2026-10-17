# dotfiles

Minhas configs de Linux (Arch, roda no WSL também), organizadas pro [GNU Stow](https://www.gnu.org/software/stow/).
Cada pasta do topo é um "pacote": espelha a home (`~`) e vira symlinks lá.

| Pacote | O que tem |
|---|---|
| `bash` | `.bashrc`, `.bash_profile`, `.inputrc` (com hook do direnv) |
| `git`  | `~/.config/git/config` e o ignore global |
| `nvim` | `~/.config/nvim` (mini.nvim via `vim.pack`) |
| `tmux` | `~/.config/tmux/tmux.conf` (tpm se instala sozinho) |

## Máquina nova

```bash
sudo pacman -S --needed git stow direnv neovim tmux
git clone https://github.com/leonardomenezes8500/dotfiles ~/code/dotfiles
cd ~/code/dotfiles
stow -n -v bash git nvim tmux   # ensaio: mostra o que faria / conflitos
stow -v bash git nvim tmux      # cria os symlinks
```

Se acusar conflito, é porque o arquivo já existe em `~`: mova ele pra fora e rode de novo.
O `.stowrc` já passa `--target=~ --no-folding`, então é sempre rodar de dentro da pasta do repo.

Depois, crie os arquivos locais (não vão pro git):

```bash
# ~/.config/git/config.local
[user]
	name = Seu Nome
	email = seu@email
```

`~/.bashrc.local`: aliases, paths e sessões específicas daquela máquina.

## Segredos

Nada sensível entra aqui (o repo é público). Segredos e env vars de projeto ficam no
[direnv](https://direnv.net/): `.envrc` no projeto (`dotenv_if_exists`) + `.env` com os valores,
que o ignore global do git já bloqueia (`.env`, `.env.local`, `.envrc.local`). Rode `direnv allow` na pasta.
