" PLUGINS {{{

call plug#begin('~/.local/share/nvim/plugged')

" Fuzzy file finder
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Handy '[' ']' shortcuts and toggles
Plug 'tpope/vim-unimpaired'

" Update version of Solarized
Plug 'lifepillar/vim-solarized8'

call plug#end()

" }}}


" SETTINGS {{{

" Search working directory, current file directory, and subdirectories
set path=.,,**

" TODO: Pull from .gitignore and .ignore
set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildignore+=*.egg-info/**
set wildignore+=node_modules/**
set wildignore+=tags

set relativenumber

" }}}


" MAPPINGS {{{

" Hide matches
nnoremap <leader>/ :nohlsearch<CR>

" }}}


" UI {{{

" TODO: Understand true color support for iTerm2 and tmux
" let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" set termguicolors
colorscheme solarized8_dark

" }}}
