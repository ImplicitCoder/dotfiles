# dotfiles

Personal editor config files, managed as symlinks so the originals live here under version control.

There are two install targets: **server** (lean, terminal-only) and **desktop** (extends server with LSP, fuzzy finder, formatters, and git integration).

## Repository layout

```
dotfiles/
├── .vimrc                   → ~/.vimrc  (shared by vim and neovim)
├── .bash_aliases            → ~/.bash_aliases
├── .gitignore_global        → ~/.gitignore_global
├── install-server.sh        run on a server / headless machine
├── install-desktop.sh       run on a desktop Linux machine (runs server install first)
│
├── nvim/                    server neovim config
│   ├── init.lua             → ~/.config/nvim/init.lua
│   ├── lazy-lock.json       → ~/.config/nvim/lazy-lock.json
│   └── lua/
│       ├── config/
│       │   └── lazy.lua     lazy.nvim bootstrap
│       └── plugins/
│           ├── colorscheme.lua      monokai theme
│           ├── completion.lua       nvim-cmp + luasnip
│           ├── lualine.lua          status line
│           ├── neo-tree.lua         file explorer sidebar
│           ├── tmux-navigator.lua   seamless vim↔tmux pane navigation
│           ├── treesitter.lua       syntax highlighting
│           └── undotree.lua         undo history browser
│
├── desktop/
│   └── nvim/
│       ├── init.lua         → ~/.config/nvim/init.lua  (overrides server)
│       ├── lazy-lock.json   → ~/.config/nvim/lazy-lock.json  (overrides server)
│       └── lua/
│           └── plugins/     → ~/.config/nvim/lua/desktop_plugins/
│               ├── lsp.lua          Mason + nvim-lspconfig + cmp-nvim-lsp
│               ├── telescope.lua    fuzzy finder (files, grep, symbols, git)
│               ├── gitsigns.lua     git diff signs and hunk actions
│               └── conform.lua      format on save (prettier, black, stylua)
│
└── tmux/
    └── .tmux.conf           → ~/.tmux.conf
```

---

## Shell aliases (`.bash_aliases`)

Sourced by both `.bashrc` and `.zshrc`. The install script checks whether your RC file already sources it and offers to add the block if not.

| Alias | Expands to | Purpose |
|---|---|---|
| `la` | `ls -laht` | Long list, sorted by time |
| `ll` | `ls -lh` | Long list, human sizes |
| `..` / `...` / `....` | `cd ..` etc. | Quick directory ascent |
| `cp`, `mv`, `rm` | with `-i` | Prompt before overwrite/delete |
| `df`, `du`, `free` | with `-h` | Human-readable sizes |
| `grep` / `egrep` / `fgrep` | with `--color=auto` | Coloured matches |
| `gs`, `ga`, `gc`, `gp`, `gpl` | `git status/add/commit/push/pull` | Git shortcuts |
| `gl` | `git log --oneline --graph --decorate` | Pretty git log |
| `gd`, `gco`, `gb` | `git diff/checkout/branch` | More git shortcuts |
| `ports` | `ss -tulanp` | Open ports |
| `myip` | `curl -s ifconfig.me` | External IP |
| `path` | `echo $PATH \| tr ":" "\n"` | PATH, one entry per line |
| `reload` | `source ~/.bashrc` | Reload shell config |
| `mkd` | `mkdir -p` | Create directory tree |
| `which` | `type -a` | All matches, not just first |

---

## Vim/Neovim base config (`.vimrc`)

Sensible defaults shared by vim and neovim:

- UTF-8, 1000-level undo, auto-reload on external changes
- Line numbers, scrolloff, wildmenu, status line
- Incremental + highlighted search, smart case
- 4-space indentation (2-space override for yaml/json/sh)
- Strip trailing whitespace on save
- Monokai colour scheme

Key mappings (leader is `,`):

| Mapping | Action |
|---|---|
| `jj` | Exit insert mode |
| `<C-h/j/k/l>` | Navigate splits |
| `<leader>w/q/x` | Save / quit / save+quit |
| `<leader>y` | Yank to system clipboard (visual) |
| `H` / `L` | Jump to start/end of line |
| `<A-Up/Down>` | Move line(s) up/down |
| `<CR>` | Clear search highlight |
| `<C-d/u>` | Half-page scroll, centred |

---

## Server neovim plugins (`nvim/lua/plugins/`)

`init.lua` sources `.vimrc`, then bootstraps [lazy.nvim](https://github.com/folke/lazy.nvim) and loads all plugin specs. `lazy-lock.json` pins exact versions — commit it to reproduce the environment exactly on another machine.

| Plugin | Purpose |
|---|---|
| vim-monokai | Colour scheme |
| nvim-cmp + LuaSnip | Autocompletion (buffer, path, snippets) |
| lualine.nvim | Status line |
| neo-tree.nvim | File explorer sidebar (`<leader>e`) |
| vim-tmux-navigator | `<C-h/j/k/l>` across vim splits and tmux panes |
| nvim-treesitter | Syntax highlighting for bash, py, ts, lua, etc. |
| undotree | Visual undo history (`<leader>u`) |

---

## Desktop neovim plugins (`desktop/nvim/lua/plugins/`)

The desktop `init.lua` tells lazy.nvim to load both `plugins/` (server) and `desktop_plugins/` (desktop), so all server plugins are present too. Mason handles downloading LSP servers, linters, and formatters automatically on first launch.

### LSP (`lsp.lua`)

Mason auto-installs: `lua_ls`, `pyright`, `ts_ls`, `eslint`, `cssls`, `html`.

Keymaps activate only when a server attaches to a buffer:

| Mapping | Action |
|---|---|
| `gd` / `gD` | Go to definition / declaration |
| `gr` / `gi` | References / implementation |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>d` | Open diagnostic float |

ESLint runs fix-all automatically on save.

### Telescope (`telescope.lua`)

| Mapping | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>fs` | Document symbols |
| `<leader>fd` | Diagnostics |
| `<leader>gc` | Git commits |
| `<leader>gs` | Git status |

Requires `ripgrep` (live grep) and `fd` (file finder) — the desktop install handles both.

### Gitsigns (`gitsigns.lua`)

Git diff markers in the sign column, with hunk-level staging and preview.

| Mapping | Action |
|---|---|
| `]h` / `[h` | Next / previous hunk |
| `<leader>hs` / `hr` | Stage / reset hunk |
| `<leader>hS` / `hR` | Stage / reset entire buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line (full) |
| `<leader>hd` | Diff this |

### Conform (`conform.lua`)

Format on save, per file type:

| File type | Formatter |
|---|---|
| Python | black |
| JS / TS / JSX / TSX | prettier |
| JSON / YAML / HTML / CSS / Markdown | prettier |
| Lua | stylua |

Mason auto-installs `black`, `prettier`, and `stylua`.

---

## Installing on a new machine

### Server

```bash
git clone https://github.com/implicitcoder/dotfiles.git ~/software/dotfiles
bash ~/software/dotfiles/install-server.sh
nvim   # lazy.nvim bootstraps and installs plugins
```

**Prerequisites:** git. The script installs tmux and neovim ≥ 0.10 (adds the neovim-ppa/unstable PPA on Ubuntu/Debian).

### Desktop

```bash
git clone https://github.com/implicitcoder/dotfiles.git ~/software/dotfiles
bash ~/software/dotfiles/install-desktop.sh
nvim   # lazy.nvim + Mason install everything on first launch
```

The desktop script runs the server install first, then additionally installs node/npm, ripgrep, fd, xclip, build tools, and FiraCode Nerd Font. It overrides `~/.config/nvim/init.lua` with the desktop version and adds a `desktop_plugins/` symlink into the nvim lua path.

**Set your terminal font to FiraCode Nerd Font** (or another Nerd Font v3) after install for neo-tree and lualine icons to render correctly.

### Manual install (server)

```bash
REPO=~/software/dotfiles

ln -sf "$REPO/.vimrc"            ~/.vimrc
ln -sf "$REPO/.bash_aliases"     ~/.bash_aliases
ln -sf "$REPO/.gitignore_global" ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global

mkdir -p ~/.config/nvim/lua
ln -sf "$REPO/nvim/init.lua"           ~/.config/nvim/init.lua
ln -sf "$REPO/nvim/lazy-lock.json"     ~/.config/nvim/lazy-lock.json
ln -sf "$REPO/nvim/lua/config"         ~/.config/nvim/lua/config
ln -sf "$REPO/nvim/lua/plugins"        ~/.config/nvim/lua/plugins

ln -sf "$REPO/tmux/.tmux.conf"   ~/.tmux.conf
```

---

## Keeping in sync

After editing config on one machine:

```bash
cd ~/software/dotfiles
git add -p
git commit -m "describe what changed"
git push
```

On another machine:

```bash
cd ~/software/dotfiles
git pull
# nvim picks up changes immediately via the symlinks — no further steps needed
```

If you update plugins (`:Lazy update` in nvim), the appropriate `lazy-lock.json` will change. Commit it so other machines get the same versions on next pull. The server and desktop each have their own lock file.
