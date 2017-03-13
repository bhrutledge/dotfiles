set nocompatible              " be iMproved
filetype off                  " required!
set encoding=utf-8

" ==========================================================
" Plugins
" TODO: http://vimawesome.com/
" TODO: Look at NeoBundle and VimPlug
" ==========================================================

" Plugin loading
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()
Plugin 'gmarik/vundle'

" Per-project vim settings
Plugin 'localvimrc'
let g:localvimrc_persistent=2
" let g:localvimrc_sandbox=0

" Auto-save and load folds and cursor position
" TODO: Setting cwd when it shouldn't
" Plugin 'restore_view.vim'
" set viewoptions=cursor,folds,slash,unix

" Fast and smart grep replacement
" Plugin 'rking/ag.vim'

" Populate argument list from quickfix list
" Plugin 'nelstrom/vim-qargs'

" Enhanced multi-file search for Vim
Plugin 'wincent/ferret'

" Fuzzy file/buffer/tag search
Plugin 'ctrlpvim/ctrlp.vim'
" TODO: b:var, or localvimrc?
let g:ctrlp_root_markers = ['tags']
let g:ctrlp_working_path_mode = 'rw'
let g:ctrlp_map = '<c-p><c-p>'
let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_follow_symlinks = 1

" http://web.archive.org/web/20151006024133/http://blog.patspam.com/2014/super-fast-ctrlp
" TODO: Redundant ignore lines?
let g:ctrlp_user_command = 'ag %s -i -l --nocolor --nogroup --hidden -g ""'

Plugin 'FelikZ/ctrlp-py-matcher'
" TODO: Case sensitivity and ordering, esp. w/ tags
" let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

" Class/method/function sidebar
Plugin 'majutsushi/tagbar'
let g:tagbar_width=60
let g:tagbar_sort=0
let g:tagbar_show_linenumbers=-1
" Update tagbar every second
set updatetime=1000

" Extend % matching to if/else, <div></div>, etc.
Plugin 'tmhedberg/matchit'
Plugin 'voithos/vim-python-matchit'

" Move through variable_names and ClassNames
Plugin 'bkad/CamelCaseMotion'

" Asynchronous build and test dispatcher
" TODO mkdir: /tmp/: Operation not permitted
" Plugin 'tpope/vim-dispatch'

" Enhance netrw
Plugin 'tpope/vim-vinegar'

" Smarter use of '.' with plugins
Plugin 'tpope/vim-repeat'

" Insert/change/delete surrounding text pairs
Plugin 'tpope/vim-surround'

" Handy '[' ']' shortcuts and toggles
Plugin 'tpope/vim-unimpaired'

" Find and subsitute word (eg., case) variations
Plugin 'tpope/vim-abolish'

" Unix shell commands (:Remove, :Rename, etc.)
Plugin 'tpope/vim-eunuch'

" Git commands
Plugin 'tpope/vim-fugitive'

" Git diff status in gutter
Plugin 'airblade/vim-gitgutter'

" Easy commenting
Plugin 'tomtom/tcomment_vim'

" Detect `shiftwidth`, etc.
" Plugin 'tpope/vim-sleuth'

" Display indent levels
Plugin 'nathanaelkane/vim-indent-guides'
let g:indent_guides_guide_size=1

" Fast HTML generation
Plugin 'mattn/emmet-vim'

" SQL execution/completion
Plugin 'dbext.vim'
let g:sql_type_default = 'mysql'

" Syntax highlighting
Plugin 'pangloss/vim-javascript'
Plugin 'othree/html5.vim'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'chase/vim-ansible-yaml'
Plugin 'chrisbra/csv.vim'
Plugin 'wannesm/wmgraphviz.vim'

" Syntax checking
Plugin 'scrooloose/syntastic'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { "mode": "passive" }

" TODO: Shiftwidth
" Plugin 'tpope/vim-markdown'
" Plugin 'gabrielelana/vim-markdown'
Plugin 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled=1
let g:vim_markdown_conceal = 0

Plugin 'reedes/vim-pencil'
" default is 'hard'
let g:pencil#wrapModeDefault = 'soft'
let g:pencil#conceallevel = 0

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  " autocmd FileType text call pencil#init({'wrap': 'hard'})
augroup END

Plugin 'itspriddle/vim-marked'

Plugin 'hdima/python-syntax'
Plugin 'hynek/vim-python-pep8-indent'
" Plugin 'nvie/vim-flake8'
Plugin 'jmcantrell/vim-virtualenv'

" TODO: Slow!
Plugin 'davidhalter/jedi-vim'
let g:jedi#show_call_signatures = 2
let g:jedi#popup_on_dot = 0
let g:jedi#smart_auto_mappings = 0

" Plugin 'klen/python-mode'
" let g:pymode_lint=0
" let g:pymode_rope_autoimport=0

let python_highlight_all=1

" Offline docs
Plugin 'rizzatti/dash.vim'

" Color scheme
Plugin 'BlackIkeEagle/vim-colors-solarized'

" Super-charged status line
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Don't duplicate Insert/Replace/Visual with Airline
set noshowmode
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#wordcount#enabled = 0
let g:airline#extensions#virtualenv#enabled = 0
let g:airline#extensions#tagbar#flags = 'f'
let g:airline#extensions#whitespace#trailing_format = 'ws[%s]'
let g:airline#extensions#whitespace#mixed_indent_format = 'in[%s]'

function! AirlineInit()
    let g:airline_section_c = airline#section#create(['%{pathshorten(fnamemodify(getcwd(), ":~"))}', ' > ', 'file'])
endfunction
autocmd VimEnter * call AirlineInit()

" Toggle quickfix
Plugin 'milkypostman/vim-togglelist'

call vundle#end()

let g:netrw_liststyle=3

" Started from https://github.com/jeffknupp/config_files/blob/master/.vimrc

" ==========================================================
" Basic Settings
" ==========================================================
syntax on                     " syntax highlighing
filetype plugin indent on     " enable loading indent file for filetype
"set title                     " show title in console title bar
set wildmenu                  " Menu completion in command mode on <Tab>
set wildmode=full             " <Tab> cycles between all matching choices.
set path=.,,**

" don't bell or blink
set noerrorbells
set visualbell t_vb=

" Ignore these files when completing
set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildignore+=*.egg-info/**
set wildignore+=tags

" No extra info during auto-complete
" set completeopt-=preview

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
set linebreak               " don't wrap text in the middle of a word
set autoindent              " always set autoindenting on
" set smartindent             " use smart indent if there is no indent file
set tabstop=4               " Render <Tab> characters as 4 spaces
set shiftwidth=4            " but an indent level is 4 spaces wide
set softtabstop=4           " and typing <Tab> or <BS> indents 4 spaces.
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
set confirm                 " Always confirm when :q, :w, etc. fails

"""" Messages, Info, Status
set showcmd                 " Show incomplete normal mode commands as I type.
set report=0                " : commands always print changed line count.
set shortmess+=a            " Use [+]/[RO]/[w] for modified/readonly/written.
set ruler                   " Show some info, even without statuslines.
set laststatus=2            " Always show statusline, even if only 1 window.
set spelllang=en_us         " Set spell check language

""" Searching and Patterns
" set ignorecase              " Default to using case insensitive searches,
" set smartcase               " unless uppercase letters are used in the regex.
set hlsearch                " Highlight searches by default.
set incsearch               " Incrementally search while typing a /regex

""" Line Numbers
set nonumber                " Display line numbers
set relativenumber          " Display relative line numbers

""" GUI
set guioptions=             " Disable all scrollbars, menus, etc.

" ==========================================================
" Filetypes
" ==========================================================

autocmd FileType crontab setlocal nobackup nowritebackup
autocmd FileType markdown,mkd let b:surround_{char2nr('_')} = "__\r__"
autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2
autocmd BufNewFile,BufRead Vagrantfile set filetype=ruby
" TODO Isolate to a directory, maybe by presence of manage.py
autocmd BufNewFile,BufRead ~/Code/*/templates/*.html set filetype=htmldjango
autocmd BufNewFile,BufRead ~/Code/*/templates/*.txt set filetype=django

" ==========================================================
" Shortcuts
" ==========================================================

" Sudo write this
cmap W! w !sudo tee % >/dev/null

" For when we forget to use sudo to open/edit a file
cmap w!! w !sudo tee % >/dev/null

" Reload Vimrc
nmap <silent> <leader>sv :source $MYVIMRC<CR>
            \:filetype detect<CR>
            \:echo 'sourced ' . $MYVIMRC<CR>

" Refresh syntax highlighting
nnoremap <leader>ss :syntax sync fromstart<CR>

" Highlight syntax errors
nnoremap <leader>sc :SyntasticCheck<CR>
nnoremap <leader>sr :SyntasticReset<CR>

" Hide matches
nnoremap <leader>/ :nohlsearch<CR>

" Remove trailing whitespace
nnoremap <leader>sw :%s/\s\+$//<CR>:let @/=''<CR>

" Set working directory
nnoremap <leader>. :lcd %:p:h \| pwd<CR>
cabbrev ph <c-r>=expand("%:p:h")<CR>

" Toggle line numbers
nnoremap com :set number! relativenumber!<CR>

" Preserve last substitution flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Quickly search for files, functions, classes, etc.
nnoremap <c-p><c-f> :CtrlP<CR>
nnoremap <c-p><c-b> :CtrlPBuffer<CR>
nnoremap <c-p><c-r> :CtrlPMRU<CR>
nnoremap <c-p><c-t> :CtrlPTag<CR>
nnoremap <c-p><c-l> :CtrlPLine<CR>

" Display tag list
noremap <leader>t :TagbarToggle<CR>

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
nnoremap <silent> <c-w>v :vnew<CR>
nnoremap <leader>v :vertical<space>

nmap <leader>ag <Plug>(FerretAck)
nmap <leader>aw <Plug>(FerretAckWord)
nmap <leader>ar <Plug>(FerretAcks)
nmap <leader>al <Plug>(FerretLack)
" TODO Escape spaces, trim whitespace
nmap <leader>ay :Ack <c-r>"
" TODO Visual selection

" nnoremap <leader>ap :Ack -G \.py<space>
" nnoremap <leader>au :Ack -G urls\.py<space>
" nnoremap <leader>ah :Ack -G \.html<space>
" nnoremap <leader>as :Ack -G \.scss<space>
" nnoremap <leader>ay :Ack -G \.yml<space>
" nnoremap <leader>aj :Ack -G \.js<space>

nmap <silent> <leader>D <Plug>DashSearch

nnoremap <leader>fi :setlocal foldmethod=indent foldenable<CR>
nnoremap <leader>fs :setlocal foldmethod=syntax foldenable<CR>
nnoremap <leader>fe :setlocal foldenable<CR>
nnoremap <leader>fn :setlocal nofoldenable<CR>

call camelcasemotion#CreateMotionMappings('<leader>')

" Force case-sensitive search for tags
" fun! MatchCaseTag()
"     let ic = &ic
"     set noic
"     try
"         exe 'tjump ' . expand('<cword>')
"     finally
"        let &ic = ic
"     endtry
" endfun
" nnoremap <silent> <c-]> :call MatchCaseTag()<CR>

iabbrev TD TODO

" Monday, November 28, 2016
iabbrev <expr> dt strftime("%A, %B %d, %Y")
cabbrev <expr> dt strftime("%Y-%m-%d")

" 15:14
iabbrev <expr> tm strftime("%H:%M")

" ==========================================================
" Colors and Fonts
" ==========================================================
set colorcolumn=+1          " Hightlight textwidth to avoid long lines
set listchars=tab:▸\ ,eol:¬ " Show hidden characters (using :set list)
set guifont=Hack:h12

set background=dark
let g:solarized_hitrail=1
colorscheme solarized

" ==========================================================
" tmux.vim - Set xterm input codes passed by tmux
" http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/examples/xterm-keys.vim
" Author:        Mark Oteiza
" License:       Public domain
" Description:   Simple plugin that assigns some xterm(1)-style keys to escape
" sequences passed by tmux when "xterm-keys" is set to "on".  Inspired by an
" example given by Chris Johnsen at:
"     https://stackoverflow.com/a/15471820
"
" Documentation: help:xterm-modifier-keys man:tmux(1)
" ==========================================================

if exists("g:loaded_tmux") || &cp
  finish
endif
let g:loaded_tmux = 1

function! s:SetXtermCapabilities()
  set ttymouse=sgr

  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"

  execute "set <xHome>=\e[1;*H"
  execute "set <xEnd>=\e[1;*F"

  execute "set <Insert>=\e[2;*~"
  execute "set <Delete>=\e[3;*~"
  execute "set <PageUp>=\e[5;*~"
  execute "set <PageDown>=\e[6;*~"

  execute "set <xF1>=\e[1;*P"
  execute "set <xF2>=\e[1;*Q"
  execute "set <xF3>=\e[1;*R"
  execute "set <xF4>=\e[1;*S"

  execute "set <F5>=\e[15;*~"
  execute "set <F6>=\e[17;*~"
  execute "set <F7>=\e[18;*~"
  execute "set <F8>=\e[19;*~"
  execute "set <F9>=\e[20;*~"
  execute "set <F10>=\e[21;*~"
  execute "set <F11>=\e[23;*~"
  execute "set <F12>=\e[24;*~"

  execute "set t_kP=^[[5;*~"
  execute "set t_kN=^[[6;*~"
endfunction

if exists('$TMUX')
  call s:SetXtermCapabilities()
endif
