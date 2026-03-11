#!/usr/bin/env bash
set -e

REPO="$(cd "$(dirname "$0")" && pwd)"

# ── Run server install first ───────────────────────────────────────────────────
echo "=== Running server (base) install ==="
bash "$REPO/install-server.sh"
echo ""

# ── Install desktop-specific packages ─────────────────────────────────────────
install_desktop_packages() {
  # Node.js / npm: required by TypeScript LSP, ESLint LSP, and Prettier.
  # ripgrep: required by telescope's live_grep.
  # fd-find: used by telescope for faster file discovery.
  # xclip: clipboard integration (tmux copy → system clipboard).
  # build-essential / base-devel: needed to compile telescope-fzf-native.
  local pkgs_dnf=(nodejs npm ripgrep fd-find xclip gcc make)
  local pkgs_pacman=(nodejs npm ripgrep fd xclip base-devel)
  local pkgs_brew=(node ripgrep fd)

  echo "Installing desktop packages..."
  if command -v apt-get &>/dev/null; then
    # On Ubuntu/Debian the distro nodejs is typically too old, and the distro
    # npm conflicts with the NodeSource bundle (NodeSource's nodejs ships npm
    # inside it — installing both causes broken-package errors).
    # Strategy: always install nodejs via NodeSource, never install the distro
    # npm package separately.
    local node_major=0
    if command -v node &>/dev/null; then
      node_major=$(node --version 2>/dev/null | sed 's/v\([0-9]*\).*/\1/')
    fi
    if [ "$node_major" -lt 18 ]; then
      echo "Node.js < 18 (or absent) — installing via NodeSource LTS (v20)..."
      # Remove any conflicting distro packages before adding the PPA so apt
      # does not try to satisfy two competing nodejs/npm providers at once.
      sudo apt-get remove -y nodejs npm 2>/dev/null || true
      curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    fi
    # npm is intentionally absent: NodeSource's nodejs bundle includes it.
    sudo apt-get update -qq
    sudo apt-get install -y nodejs ripgrep fd-find xclip build-essential
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y "${pkgs_dnf[@]}"
  elif command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm "${pkgs_pacman[@]}"
  elif command -v brew &>/dev/null; then
    brew install "${pkgs_brew[@]}"
  else
    echo "ERROR: Cannot detect package manager. Install manually: node, npm, ripgrep, fd, xclip" >&2
    exit 1
  fi
}

install_desktop_packages

# ── Install a Nerd Font (FiraCode) ─────────────────────────────────────────────
# Required for neo-tree icons and lualine separators.
# Skipped if a Nerd Font is already installed or on non-X11/Wayland systems.
install_nerd_font() {
  local font_dir="$HOME/.local/share/fonts"
  if fc-list | grep -qi "NerdFont\|Nerd Font"; then
    echo "A Nerd Font is already installed — skipping font install"
    return
  fi

  if ! command -v fc-cache &>/dev/null; then
    echo "fontconfig not found — skipping Nerd Font install (install manually)"
    return
  fi

  echo "Downloading FiraCode Nerd Font..."
  local version="3.2.1"
  local url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/FiraCode.zip"
  local tmpdir
  tmpdir=$(mktemp -d)
  curl -fsSL "$url" -o "$tmpdir/FiraCode.zip"
  mkdir -p "$font_dir"
  unzip -q "$tmpdir/FiraCode.zip" -d "$font_dir/FiraCodeNerdFont"
  fc-cache -fv "$font_dir" > /dev/null
  rm -rf "$tmpdir"
  echo "FiraCode Nerd Font installed. Set it as your terminal font."
}

install_nerd_font

# ── Desktop neovim symlinks ────────────────────────────────────────────────────
# Override init.lua with the desktop version (loads both plugins + desktop_plugins)
ln -sf "$REPO/desktop/nvim/init.lua" ~/.config/nvim/init.lua
echo "Symlinked desktop nvim/init.lua (loads base plugins + desktop plugins)"

# Override lazy-lock.json with the desktop one (tracks desktop plugin versions)
ln -sf "$REPO/desktop/nvim/lazy-lock.json" ~/.config/nvim/lazy-lock.json
echo "Symlinked desktop nvim/lazy-lock.json"

# Add desktop_plugins/ alongside the existing lua/plugins/ symlink.
# lazy.nvim will scan both directories (see desktop/nvim/init.lua spec).
ln -sf "$REPO/desktop/nvim/lua/plugins" ~/.config/nvim/lua/desktop_plugins
echo "Symlinked desktop_plugins/ into nvim lua path"

echo ""
echo "Desktop symlinks created. Open nvim to let lazy.nvim install desktop plugins."
echo "Mason will download LSP servers, formatters, and linters on first launch."
echo ""
echo "Keymaps added by desktop plugins:"
echo "  LSP (active when a server attaches):"
echo "    gd / gD       — go to definition / declaration"
echo "    gr / gi       — references / implementation"
echo "    K             — hover docs"
echo "    <leader>rn    — rename symbol"
echo "    <leader>ca    — code action"
echo "    [d / ]d       — previous / next diagnostic"
echo "    <leader>d     — open diagnostic float"
echo "  Telescope:"
echo "    <leader>ff    — find files"
echo "    <leader>fg    — live grep"
echo "    <leader>fb    — buffers"
echo "    <leader>fr    — recent files"
echo "    <leader>fs    — document symbols"
echo "    <leader>fd    — diagnostics"
echo "    <leader>gc    — git commits"
echo "  Git (gitsigns):"
echo "    ]h / [h       — next / prev hunk"
echo "    <leader>hs/r  — stage / reset hunk"
echo "    <leader>hp    — preview hunk"
echo "    <leader>hb    — blame line"
