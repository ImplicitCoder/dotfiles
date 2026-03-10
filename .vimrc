" ============================================
"  .vimrc — sensible defaults
" ============================================

" --- General ---
set nocompatible
set encoding=utf-8
set history=1000
set undolevels=1000
set undofile                    " persist undo history across sessions
set autoread                    " reload file if changed outside vim
silent! colorscheme monokai

" --- UI ---
set number                      " line numbers
set scrolloff=8                 " keep 8 lines above/below cursor
set sidescrolloff=8
set wrap                        " wrap long lines
set showmatch                   " highlight matching brackets
set wildmenu                    " enhanced command completion
set wildmode=list:longest
set laststatus=2                " always show status line
set ruler                       " show cursor position
set showcmd                     " show incomplete commands
set noerrorbells                " no beeping
set visualbell

" --- Search ---
set incsearch                   " search as you type
set hlsearch                    " highlight search results
set ignorecase                  " case insensitive search...
set smartcase                   " ...unless uppercase is used

" --- Indentation ---
set autoindent
set smartindent
set expandtab                   " spaces instead of tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4

" --- Splits ---
set splitbelow                  " new horizontal split goes below
set splitright                  " new vertical split goes right

" ============================================
"  Mappings
" ============================================

let mapleader = ","             " space as leader key

" jj to exit insert mode
inoremap jj <Esc>

" Move lines up/down in normal mode with Alt+Up/Down
nnoremap <A-Up>   :m .-2<CR>==
nnoremap <A-Down> :m .+1<CR>==

" Move lines up/down in visual mode
vnoremap <A-Up>   :m '<-2<CR>gv=gv
vnoremap <A-Down> :m '>+1<CR>gv=gv

" Clear search highlight with Enter
nnoremap <CR> :nohlsearch<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Open/close folds with space in normal mode (when in fold)
nnoremap <leader>z za

" Jump to start/end of line more easily
nnoremap H ^
nnoremap L $

" Keep visual selection after indent
vnoremap < <gv
vnoremap > >gv

" Leader + y yanks to system clipboard in visual mode
vnoremap <leader>y "+y

" Paste without overwriting register
vnoremap p "_dP

" Y behaves like D and C (yank to end of line)
nnoremap Y y$

" Center screen after jumping
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" ============================================
"  File type niceties
" ============================================
filetype plugin indent on
syntax on

autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType json setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType sh   setlocal tabstop=2 shiftwidth=2 softtabstop=2

" Strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e
