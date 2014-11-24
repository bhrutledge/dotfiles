set nocompatible              " be iMproved
filetype off                  " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

set encoding=utf-8

" TODO: :%s/Bundle/Plugin/g
Bundle 'gmarik/vundle'
Bundle 'localvimrc'
Bundle 'rking/ag.vim'
Bundle 'kien/ctrlp.vim'
Bundle 'majutsushi/tagbar'
Bundle 'tmhedberg/matchit'
Bundle 'voithos/vim-python-matchit'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-abolish'
"Bundle 'tpope/vim-commentary'
Bundle 'tomtom/tcomment_vim'
Bundle 'tpope/vim-fugitive'
Bundle 'plasticboy/vim-markdown'
Bundle 'othree/html5.vim'
Bundle 'mattn/emmet-vim'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'hdima/python-syntax'
Bundle 'hynek/vim-python-pep8-indent'
Bundle 'nvie/vim-flake8'
"Bundle 'klen/python-mode'
"Bundle 'scrooloose/syntastic'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'altercation/vim-colors-solarized'
Bundle 'bling/vim-airline'

" ==========================================================
" Plugin Settings
" ==========================================================

let g:netrw_liststyle=3
" TODO: b:var, or localvimrc?
let g:ctrlp_root_markers = ['tags']
let g:ctrlp_working_path_mode = 'rw'
let g:tagbar_width=60
let g:tagbar_sort=0
let g:tagbar_show_linenumbers=-1
" Update tagbar every second
set updatetime=1000
let g:vim_markdown_folding_disabled=1
let g:indent_guides_guide_size=1
let g:localvimrc_persistent=1
let python_highlight_all=1
" Don't duplicate Insert/Replace/Visual with Airline
set noshowmode

autocmd FileType python setlocal completeopt-=preview

" Started from https://github.com/jeffknupp/config_files/blob/master/.vimrc

" ==========================================================
" Basic Settings
" ==========================================================
syntax on                     " syntax highlighing
filetype on                   " try to detect filetypes
filetype plugin indent on     " enable loading indent file for filetype
"set title                     " show title in console title bar
set wildmenu                  " Menu completion in command mode on <Tab>
set wildmode=full             " <Tab> cycles between all matching choices.

" don't bell or blink
set noerrorbells
set visualbell t_vb=

" Ignore these files when completing
set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildignore+=*.egg-info/**
set wildignore+=tags

" Disable the colorcolumn when switching modes.  Make sure this is the
" first autocmd for the filetype here
"autocmd FileType * setlocal colorcolumn=0

""" Moving Around/Editing
set nostartofline           " Avoid moving cursor to BOL when jumping around
set virtualedit=block       " Let cursor move past the last char in <C-v> mode
set scrolloff=3             " Keep 3 context lines above and below the cursor
set backspace=2             " Allow backspacing over autoindent, EOL, and BOL
set showmatch               " Briefly jump to a paren once it's balanced
set wrap                    " Wrap text
set linebreak               " don't wrap textin the middle of a word
set autoindent              " always set autoindenting on
"set smartindent             " use smart indent if there is no indent file
set tabstop=4               " <tab> inserts 4 spaces
set shiftwidth=4            " but an indent level is 2 spaces wide.
set softtabstop=4           " <BS> over an autoindent deletes both spaces.
set expandtab               " Use spaces, not tabs, for autoindent/tab key.
set shiftround              " rounds indent to a multiple of shiftwidth
set formatoptions=tcroql    " Setting text and comment formatting to auto
set textwidth=79            " Lines are automatically wrapped after 79 columns
set splitright              " Open new vertical windows to the right
set splitbelow              " Open new horizontal windows on the bottom

"""" Reading/Writing
set noautowrite             " Never write a file unless I request it.
set noautowriteall          " NEVER.
set noautoread              " Don't automatically re-read changed files.
set modelines=0             " Don't allow modelines

"""" Messages, Info, Status
set showcmd                 " Show incomplete normal mode commands as I type.
set report=0                " : commands always print changed line count.
set shortmess+=a            " Use [+]/[RO]/[w] for modified/readonly/written.
set ruler                   " Show some info, even without statuslines.
set laststatus=2            " Always show statusline, even if only 1 window.
set spelllang=en_us         " Set spell check language

""" Searching and Patterns
set ignorecase              " Default to using case insensitive searches,
set smartcase               " unless uppercase letters are used in the regex.
set hlsearch                " Highlight searches by default.
set incsearch               " Incrementally search while typing a /regex

""" Line Numbers
set nonumber                    " Display line numbers
set relativenumber             " Display relative line numbers

" ==========================================================
" Shortcuts
" ==========================================================

" sudo write this
cmap W! w !sudo tee % >/dev/null

" for when we forget to use sudo to open/edit a file
cmap w!! w !sudo tee % >/dev/null

" Reload Vimrc
nmap <silent> <leader>V 
           \:source ~/.vimrc<CR>
            \:filetype detect<CR>
            \:exe ":echo 'vimrc reloaded'"<CR>

" Open/close the quickfix window
nmap <leader>co :copen<CR>
nmap <leader>cc :cclose<CR>

" Quit window on <leader>q
nnoremap <leader>q :conf q<CR>

" Hide matches on <leader>space
nnoremap <leader><space> :nohlsearch<cr>

" Remove trailing whitespace on <leader>rws
nnoremap <leader>rws :%s/\s\+$//<cr>:let @/=''<CR>

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Toggle line numbers
nnoremap <leader>n :set nu! rnu!<CR>

" Preserve last substitution flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Toggle current-line highlight
nnoremap <leader>cl :set cursorline!<CR>

" Toggle spell check
nnoremap <leader>sc :setlocal spell!<CR>

" Quickly search for functions, classes, etc.
nnoremap <leader><c-p> :CtrlPTag<CR>

" Display tag list
nnoremap <leader><c-t> :TagbarToggle<CR>

" ==========================================================
" Colors and Fonts
" ==========================================================
set colorcolumn=+1          " Hightlight textwidth to avoid long lines
set listchars=tab:▸\ ,eol:¬ " Show hidden characters (using :set list)
set guifont=Menlo\ Regular:h12

set background=dark
let g:solarized_hitrail=1
colorscheme solarized

