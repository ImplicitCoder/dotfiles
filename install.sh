#!/usr/bin/env bash
set -e

REPO="$(cd "$(dirname "$0")" && pwd)"

# ── Install required packages ─────────────────────────────────────────────────
install_packages() {
  local missing=()

  command -v tmux  &>/dev/null || missing+=(tmux)
  command -v nvim  &>/dev/null || missing+=(neovim)

  if [ ${#missing[@]} -eq 0 ]; then
    echo "tmux and neovim already installed — skipping package install"
    return
  fi

  echo "Installing missing packages: ${missing[*]}"

  if command -v apt-get &>/dev/null; then
    sudo apt-get update -qq && sudo apt-get install -y "${missing[@]}"
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y "${missing[@]}"
  elif command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm "${missing[@]}"
  elif command -v brew &>/dev/null; then
    brew install "${missing[@]}"
  else
    echo "ERROR: Cannot detect package manager. Install manually: ${missing[*]}" >&2
    exit 1
  fi
}

install_packages

# ── Dotfile symlinks ──────────────────────────────────────────────────────────
ln -sf "$REPO/.vimrc" ~/.vimrc
ln -sf "$REPO/.bash_aliases" ~/.bash_aliases
echo "Symlinked .bash_aliases"

# Check that RC files source ~/.bash_aliases; offer to patch them if not
for RC in ~/.bashrc ~/.zshrc; do
  [ -f "$RC" ] || continue
  if grep -q 'bash_aliases' "$RC"; then
    echo "$RC already sources .bash_aliases — skipping"
  else
    echo ""
    echo "Warning: $RC does not source ~/.bash_aliases"
    read -rp "Add sourcing block to $RC? [y/N] " _answer
    if [[ "$_answer" =~ ^[Yy]$ ]]; then
      printf '\n# Load shared aliases\nif [ -f ~/.bash_aliases ]; then\n  . ~/.bash_aliases\nfi\n' >> "$RC"
      echo "Added sourcing block to $RC"
    else
      echo "Skipped. Add manually:"
      echo '  [ -f ~/.bash_aliases ] && . ~/.bash_aliases'
    fi
  fi
done
echo ""

mkdir -p ~/.config/nvim
ln -sf "$REPO/nvim/init.lua"        ~/.config/nvim/init.lua
ln -sf "$REPO/nvim/lazy-lock.json"  ~/.config/nvim/lazy-lock.json
LUA_TARGET=~/.config/nvim/lua
if [ -d "$LUA_TARGET" ] && [ ! -L "$LUA_TARGET" ]; then
  BACKUP="${LUA_TARGET}.bak.$(date +%Y%m%d%H%M%S)"
  mv "$LUA_TARGET" "$BACKUP"
  echo "Warning: existing lua/ directory moved to $BACKUP"
fi
ln -sf "$REPO/nvim/lua" "$LUA_TARGET"

for RC in ~/.bashrc ~/.zshrc; do
  if [ -f "$RC" ] && ! grep -q "alias vim=" "$RC"; then
    echo "alias vim='nvim'" >> "$RC"
    echo "Added alias vim='nvim' to $RC"
  fi
done

# ── Tmux config ───────────────────────────────────────────────────────────────
ln -sf "$REPO/tmux/.tmux.conf" ~/.tmux.conf
echo "Symlinked .tmux.conf"

echo "Symlinks created. Open nvim to let lazy.nvim install plugins."

# Source the appropriate RC file to activate aliases in the current shell.
# This only has an effect when the script is itself sourced (. install.sh).
# When run as a subprocess, print a reminder instead.
if [[ -n "$ZSH_VERSION" ]]; then
  RC=~/.zshrc
elif [[ -n "$BASH_VERSION" ]]; then
  RC=~/.bashrc
else
  RC=""
fi

if [[ -n "$RC" && -f "$RC" ]]; then
  # shellcheck source=/dev/null
  . "$RC"
  echo "Sourced $RC — aliases are active in this shell."
  echo "(If you ran this as a subprocess, run:  source $RC)"
else
  echo "Run 'source ~/.bashrc' or 'source ~/.zshrc' to activate aliases in your current shell."
fi
