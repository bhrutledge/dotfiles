" CORE SETUP {{{

" Force Vim mode instead of Vi compatibility
set nocompatible
" Use UTF-8 encoding
set encoding=utf-8
" Remember 10000 commands in history
set history=10000
" Don't save options in session files
set sessionoptions-=options
" Fast terminal connection
set ttyfast
" Save and restore global variables
set viminfo+=!

" Enable filetype detection, plugins, and indentation
filetype plugin indent on

" }}}

" EDITING BEHAVIOR {{{

" Copy indent from current line when starting new line
set autoindent
" Allow backspacing over everything in insert mode
set backspace=indent,eol,start
" Use spaces instead of tabs, 4 spaces per tab
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
" Make <Tab> and <Backspace> work with spaces
set smarttab
" Wrap long lines at word boundaries
set linebreak
" Auto-formatting options: text, comments, auto-wrap, remove comment leader on join
set formatoptions=tcqj
" Don't scan included files for completion
set complete-=i
" Completion menu behavior: show longest match, always show menu
set completeopt=longest,menuone

" }}}

" SEARCH AND NAVIGATION {{{

" Automatically read files when changed outside vim
set autoread
" Highlight search matches
set hlsearch
" Show matches as you type search pattern
set incsearch
" Search files in working directory, current file directory, and subdirectories
set path=.,,**
" Look for tags files in current directory and up the tree
set tags=./tags;,tags

" Enhanced % matching
packadd! matchit

" }}}

" UI AND DISPLAY {{{

syntax enable
set background=dark
" set termguicolors

" Show as much as possible of the last line
set display=lastline
" Always show status line
set laststatus=2
" Show line numbers
set number
" Show cursor position in status line
set ruler
" Keep 10 lines visible above/below cursor
set scrolloff=10
" New splits open to the right and below
set splitright splitbelow
" Show tabs, trailing spaces, and non-breaking spaces
set listchars=tab:>\ ,trail:-,nbsp:+
" Enable mouse in all modes
set mouse=a

" Set terminal title: file.txt + (~/p/t/dir)
set title titlestring=%t%(\ %M%)%(\ (%{pathshorten(expand('%:~:h'))})%)

" }}}

" COMPLETION AND WILDCARDS {{{

" Enhanced command-line completion
set wildmenu
" Use popup menu for command completion
set wildoptions=pum

" Ignore compiled files and common directories
set wildignore+=*.o,*.obj,*.pyc,*.map
set wildignore+=*/.git/*
set wildignore+=*/eggs/*
set wildignore+=*.egg-info/*
set wildignore+=*/venv/*
set wildignore+=*/node_modules/*
set wildignore+=*/build/*
set wildignore+=*/dist/*
set wildignore+=*/.sass-cache/*
set wildignore+=tags

" }}}

" NETRW FILE BROWSER {{{

" File browser buffer settings: no modify, read-only, relative line numbers
let g:netrw_bufsettings = "noma nomod nobl nowrap ro rnu"
" Hide the banner
let g:netrw_banner = 0
" Tree-style listing
let g:netrw_liststyle = 3
" Open files in vertical split
let g:netrw_altv = 1
" Size of netrw window (negative = percentage)
let g:netrw_winsize = -40

" }}}

" MAPPINGS {{{

" Reload vimrc, refresh buffer to trigger autocmds
nnoremap <leader>sv :source $MYVIMRC \| edit<CR>

" Refresh syntax highlighting
nnoremap <leader>ss :syntax sync fromstart<CR>

" Remove trailing whitespace
nnoremap <leader>sw :%s/\s\+$//<CR>:let @/=''<CR>

" Clear search highlighting
nnoremap <silent> <leader>/ :let @/=''<CR>

" Set working directory to current file directory
nnoremap <leader>ch :lcd %:p:h<CR>

" Insert current file name/path/directory in command line
cnoremap ;t <c-r>=expand("%:t")<CR>
cnoremap ;p <c-r>=expand("%:p")<CR>
cnoremap ;h <c-r>=expand("%:p:h")<CR>/
cnoremap ;H <c-r>=expand("%:.:h")<CR>/

" Yank current file name/path/directory to unnamed register
nnoremap <leader>yf :let @"=@% \| echo @"<CR>
nnoremap <leader>yt :let @"=expand("%:t") \| echo @"<CR>
nnoremap <leader>yp :let @"=expand("%:p") \| echo @"<CR>
nnoremap <leader>yh :let @"=expand("%:p:h") \| echo @"<CR>
nnoremap <leader>yH :let @"=expand("%:.:h") \| echo @"<CR>

" Copy unnamed register to clipboard
nnoremap <leader>cy :let @+=@"<CR>

" Open vertical windows
nnoremap <leader>v :vertical<space>

" Display current time and date
nnoremap <leader>td :echo strftime("%l:%M %m/%d")<CR>

" Friendlier grep: don't jump, show quickfix instead of full screen output
command! -nargs=+ Grep execute 'silent grep! <args>' | redraw! | cwindow

" Use ripgrep if available
if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" }}}

" STATUS LINE {{{

" path/to/file[+]
set statusline=\ %.30f%m
" ~/c/w/dir
set statusline+=\ %#LineNR#
set statusline+=\ %{pathshorten(fnamemodify(getcwd(),':~'))}
" [Help][Preview][Quickfix List][RO]
set statusline+=%h%w%q%r
" Right aligned
set statusline+=%=
" [filetype]
set statusline+=%y
" [utf-8]
set statusline+=[%{&fileencoding?&fileencoding:&encoding}]
" [unix]
set statusline+=[%{&fileformat}]
" % Line Column
set statusline+=\ %#StatusLineNC#
set statusline+=\ %P\ %4l\ %3c\ 

" Don't show ruler (position info) since it's in statusline
set noruler

" }}}

" FILE TYPE SETTINGS {{{

augroup filetypes
    autocmd!
    autocmd FileType help setlocal relativenumber textwidth=0
    autocmd FileType vim setlocal foldmethod=marker foldlevel=1 keywordprg=:help textwidth=119
    autocmd FileType crontab setlocal nobackup nowritebackup
    autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2
    autocmd FileType markdown setlocal textwidth=0
    autocmd BufNewFile,BufRead .bash* set filetype=sh
    autocmd BufNewFile,BufRead .*envrc set filetype=sh
augroup END

" }}
