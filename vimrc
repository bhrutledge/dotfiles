set nocompatible              " be iMproved
filetype off                  " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'plasticboy/vim-markdown'
Bundle 'othree/html5.vim'
Bundle 'hdima/python-syntax'
Bundle 'nathanaelkane/vim-indent-guides'

filetype plugin indent on     " required!
syntax enable
"set background=dark
"colorscheme solarized

let mapleader=","

set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set shiftround
set autoindent
set showmatch
set hlsearch
"set number

let g:netrw_winsize=80
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:vim_markdown_folding_disabled=1
let g:indent_guides_guide_size=1

