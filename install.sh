#!/usr/bin/env bash
set -e

REPO="$(cd "$(dirname "$0")" && pwd)"

ln -sf "$REPO/.vimrc" ~/.vimrc

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

echo "Symlinks created. Open nvim to let lazy.nvim install plugins."
