" Settings based on :help nvim-defaults
" https://github.com/noahfrederick/vim-neovim-defaults

if has('autocmd')
  filetype plugin indent on
endif

" TODO: Add a colorscheme to ~/.vim/colors
" if has('syntax') && !exists('g:syntax_on')
"     syntax enable
"     set background=dark
" endif

set autoindent
set autoread
set backspace=indent,eol,start
set belloff=all
set complete-=i
set display=lastline
set encoding=utf-8
set formatoptions=tcqj
set history=10000
set hlsearch
set incsearch
set langnoremap
set laststatus=2
set listchars=tab:>\ ,trail:-,nbsp:+
set mouse=a
set nrformats=bin,hex
set sessionoptions-=options
set ruler
set smarttab
set tabpagemax=50
set tags=./tags;,tags
set ttyfast
set viminfo+=!
set wildmenu

" Load matchit.vim, if a newer version isn't already installed.
" Neovim includes matchit.vim as a regular plug-in.
if !exists("g:loaded_matchit") && findfile("plugin/matchit.vim", &runtimepath) ==# ""
  runtime! macros/matchit.vim
endif


" TODO: Consolidate remaining settings with NeoVim config

" SETTINGS {{{

" Search files in working directory, current file directory, and subdirectories
set path=.,,**

set relativenumber

set expandtab tabstop=4 shiftwidth=4 softtabstop=4

set splitright splitbelow

" Configure completion
" set omnifunc=syntaxcomplete#Complete
" set complete=.,w,b,u
set completeopt-=preview

let g:netrw_bufsettings = "noma nomod nobl nowrap ro rnu"

" }}}


" MAPPINGS {{{

" Hide matches
nnoremap <leader>/ :nohlsearch<CR>

" Refresh syntax highlighting
nnoremap <leader>ss :syntax sync fromstart<CR>

" Remove trailing whitespace
nnoremap <leader>sw :%s/\s\+$//<CR>:let @/=''<CR>

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>
cabbrev %. <c-r>=expand("%:p:h")<CR>

" Yank current file name
nnoremap <leader>yf :let @"=expand("%:t") \| echo @"<CR>

" Yank current file path (relative to :pwd)
nnoremap <leader>yp :let @"=@% \| echo @"<CR>

" Yank current file directory
nnoremap <leader>y. :let @"=expand("%:p:h") \| echo @"<CR>

" Yank current tag
nnoremap <leader>yt :let @"=tagbar#currenttag('%s', '', 'f') \| echo @"<CR>

" Copy unnamed register to clipboard
nnoremap <leader>cy :let @+=@" \| echo @+<CR>

" Open vertical windows
nnoremap <leader>v :vertical<space>

" }}}
