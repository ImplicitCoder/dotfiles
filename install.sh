#!/usr/bin/env bash
set -e

REPO="$(cd "$(dirname "$0")" && pwd)"

ln -sf "$REPO/.vimrc" ~/.vimrc

mkdir -p ~/.config/nvim
ln -sf "$REPO/nvim/init.vim"       ~/.config/nvim/init.vim
ln -sf "$REPO/nvim/lazy-lock.json" ~/.config/nvim/lazy-lock.json

echo "Symlinks created. Open nvim to let lazy.nvim install plugins."
