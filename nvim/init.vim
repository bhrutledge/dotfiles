call plug#begin('~/.local/share/nvim/plugged')

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'lifepillar/vim-solarized8'

call plug#end()

set relativenumber

" TODO: Understand true color support for iTerm2 and tmux
" let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" set termguicolors
colorscheme solarized8_dark
