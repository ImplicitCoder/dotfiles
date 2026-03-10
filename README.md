# dotfiles

Personal editor config files, managed as symlinks so the originals live here under version control.

## Contents

```
dotfiles/
├── .vimrc              → ~/.vimrc
├── install.sh          → run once on a new machine
└── nvim/
    ├── init.lua        → ~/.config/nvim/init.lua
    ├── lazy-lock.json  → ~/.config/nvim/lazy-lock.json
    └── lua/            → ~/.config/nvim/lua/
        ├── config/
        │   └── lazy.lua        lazy.nvim bootstrap + setup
        └── plugins/
            ├── colorscheme.lua
            └── neo-tree.lua
```

### `.vimrc` — shared base config

Sensible defaults used by both vim and neovim. Covers:

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

### `nvim/` — neovim extensions

`init.lua` sources `.vimrc` first, then loads `lua/config/lazy.lua` which bootstraps [lazy.nvim](https://github.com/folke/lazy.nvim) and imports all plugin specs from `lua/plugins/`:

- **colorscheme.lua** — vim-monokai, loads at startup with high priority
- **neo-tree.lua** — file explorer sidebar, opens automatically on launch, closes with the last real window. Toggle with `<leader>e`.

`lazy-lock.json` pins the exact plugin versions — commit it to reproduce the same environment on any machine.

---

## Installing on a new machine

### Prerequisites

- Git
- Neovim ≥ 0.8 (lazy.nvim requirement)
- A **Nerd Font v3** in your terminal (for neo-tree icons) — download from the [Nerd Fonts releases page](https://github.com/ryanoasis/nerd-fonts/releases/latest), extract to `~/.local/share/fonts/<FontName>/`, then run `fc-cache -f`. Note: v2 fonts will render git status icons as boxes.

### Steps

```bash
# 1. Clone this repo
git clone https://github.com/implicitcoder/dotfiles.git ~/software/dotfiles

# 2. Run the install script
bash ~/software/dotfiles/install.sh

# 3. Open nvim — lazy.nvim bootstraps itself and installs plugins automatically
nvim
```

The install script creates symlinks from the standard locations to the files in this repo. Re-running it on an existing machine is safe — it uses `ln -sf` which silently replaces any existing symlink.

### Manual install (if you prefer)

```bash
REPO=~/software/dotfiles

ln -sf "$REPO/.vimrc" ~/.vimrc

mkdir -p ~/.config/nvim
ln -sf "$REPO/nvim/init.lua"        ~/.config/nvim/init.lua
ln -sf "$REPO/nvim/lazy-lock.json"  ~/.config/nvim/lazy-lock.json
ln -sf "$REPO/nvim/lua"             ~/.config/nvim/lua
```

---

## Keeping in sync

After editing any config on one machine:

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
# nvim will pick up changes immediately via the symlinks — no further steps needed
```

If you update plugins (`nvim` → `:Lazy update`), the `lazy-lock.json` will change. Commit that too so other machines get the same versions on next pull.
