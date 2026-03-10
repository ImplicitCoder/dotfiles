#!/usr/bin/env bash
set -e

REPO="$(cd "$(dirname "$0")" && pwd)"

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

echo "Symlinks created. Open nvim to let lazy.nvim install plugins."
