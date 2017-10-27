" TODO: Create if missing
let g:python_host_prog = expand('~/.virtualenvs/neovim2/bin/python')
let g:python3_host_prog = expand('~/.virtualenvs/neovim3/bin/python')

" PLUGINS {{{

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    echo "Installing vim-plug..."
    !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.local/share/nvim/plugged')

" Fuzzy file finder
" TODO: Improve installation
Plug 'junegunn/fzf', { 'dir': '~/.local/share/nvim/fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Async :grep via multiple tools
Plug 'mhinz/vim-grepper'
let g:grepper = {}
let g:grepper.highlight = 1
let g:grepper.tools = ['rg', 'ag', 'grep', 'git']

" Smarter use of '.' with plugins
Plug 'tpope/vim-repeat'

" Insert/change/delete surrounding text pairs
Plug 'tpope/vim-surround'

" Handy '[' ']' shortcuts and toggles
Plug 'tpope/vim-unimpaired'

" Comment stuff out
Plug 'tpope/vim-commentary'

" Transition between multiline and single-line code
Plug 'AndrewRadev/splitjoin.vim'

" Text filtering and alignment
Plug 'godlygeek/tabular'

" Find and subsitute word (eg., case) variations
Plug 'tpope/vim-abolish'

" Unix shell commands (:Remove, :Rename, etc.)
Plug 'tpope/vim-eunuch'

" Git commands
Plug 'tpope/vim-fugitive'

" Git diff status in gutter
Plug 'airblade/vim-gitgutter'

" Display tags in a window
Plug 'majutsushi/tagbar'
let g:tagbar_width = 60
let g:tagbar_sort = 0
let g:tagbar_show_linenumbers = -1
" Update tagbar every second
set updatetime=1000

" Asynchronous Lint Engine
Plug 'w0rp/ale'
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

" Syntax highlighting for many languages
" Note: Individual plugins might be missing features
Plug 'sheerun/vim-polyglot'

" https://github.com/sheerun/vim-polyglot/issues/209
let g:polyglot_disabled = ['python']
let python_highlight_all = 1
Plug 'Vimjas/vim-python-pep8-indent'

" Python completion
Plug 'jmcantrell/vim-virtualenv'
Plug 'davidhalter/jedi-vim'
let g:jedi#show_call_signatures = 0
let g:jedi#popup_on_dot = 0
let g:jedi#smart_auto_mappings = 0

" JavaScript completion
Plug '1995eaton/vim-better-javascript-completion'

" Fast HTML generation
Plug 'mattn/emmet-vim'

" Asynchronous build and test dispatcher
Plug 'tpope/vim-dispatch'

" Run tests for multiple languages using different strategies
Plug 'janko-m/vim-test'

" Quick Google lookup
Plug 'szw/vim-g'

" Updated versions of Solarized
Plug 'ericbn/vim-solarized'
Plug 'lifepillar/vim-solarized8'
Plug 'iCyMind/NeoSolarized'

call plug#end()

if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    echo "Installing missing plugins...\n"
    " TODO: Progress meter or install report
    PlugUpdate --sync | q
endif

" }}}


" SETTINGS {{{

" Search files in working directory, current file directory, and subdirectories
set path=.,,**

" TODO Pull from .gitignore and .ignore
set wildignore+=*.o,*.obj,.git,*.pyc,*.map
set wildignore+=eggs/**
set wildignore+=*.egg-info/**
set wildignore+=node_modules/**
set wildignore+=tags

set relativenumber signcolumn=yes
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
set textwidth=79 colorcolumn=+1
set scrolloff=10
set splitright splitbelow

" Set terminal title: file.txt + ~/p/t/dir
set title
set titlestring=%t%(\ %M%)%(\ (%{pathshorten(expand('%:~:h'))})%)

" Configure completion
" set omnifunc=syntaxcomplete#Complete
" set complete=.,w,b,u
set completeopt-=preview

let g:netrw_bufsettings = "noma nomod nobl nowrap ro rnu"

set background=dark

if $ITERM_PROFILE == 'Default' || has('gui_vimr')
    set termguicolors
endif

" colorscheme solarized
" colorscheme solarized8_dark
colorscheme NeoSolarized

" }}}


" AUTOCOMMANDS {{{

augroup startup
    autocmd!
    " Change to file directory if started from $HOME (e.g., via GUI), to improve grep
    autocmd BufEnter * if getcwd() == $HOME | silent! lcd %:p:h | endif
augroup END

" TODO: When this gets big, consider moving to after/ftplugin/<filetype>.vim
augroup filetypes
    autocmd!
    autocmd FileType help setlocal relativenumber textwidth=0
    autocmd FileType vim setlocal foldmethod=marker foldlevel=1 keywordprg=:help textwidth=119
    autocmd FileType crontab setlocal nobackup nowritebackup
    autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2
    autocmd FileType htmldjango setlocal commentstring={#\ %s\ #}
    autocmd FileType markdown setlocal textwidth=0
    autocmd BufNewFile,BufRead Vagrantfile set filetype=ruby
    autocmd BufNewFile,BufRead .babelrc set filetype=json
    autocmd BufNewFile,BufRead .bash* set filetype=sh
    autocmd BufNewFile,BufRead .*envrc set filetype=sh
    autocmd TermOpen * setlocal relativenumber
augroup END

" TODO: When this gets big, consider using sourced files or localvimrc
augroup code_es
    autocmd!
    autocmd BufNewFile,BufRead ~/Code/{es,es-*}/* setlocal textwidth=119
    " TODO: Try ftdetect based on parent directory
    autocmd BufNewFile,BufRead ~/Code/es/*.html set filetype=htmldjango
    autocmd BufNewFile,BufRead ~/Code/es/*.txt set filetype=django
augroup END

augroup test_es
    " TODO: Use dispatch to populate quickfix window
    autocmd BufNewFile,BufRead ~/Code/es/*.py
                \ let g:test#filename_modifier = ':p:s?.*es-site/es/??' |
                \ let g:test#python#runner = 'djangotest' |
                \ let g:test#python#djangotest#executable = 'python -Wignore manage.py test' |
                \ let g:test#python#djangotest#options = '-k --settings es.settings.local_dev'
augroup END

" }}}


" MAPPINGS {{{

" Hide matches
nnoremap <leader>/ :nohlsearch<CR>

" Refresh syntax highlighting
nnoremap <leader>ss :syntax sync fromstart<CR>

" Display highlight group
" https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Remove trailing whitespace
nnoremap <leader>sw :%s/\s\+$//<CR>:let @/=''<CR>

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>
cabbrev %. <c-r>=expand("%:.:h")<CR>
cabbrev %p <c-r>=expand("%:p:h")<CR>

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

" Monday, November 28, 2016
iabbrev <expr> dt strftime("%A, %B %d, %Y")
cabbrev <expr> dt strftime("%Y-%m-%d")

" 15:14
iabbrev <expr> tm strftime("%H:%M")

" Display current time and date
nnoremap <leader>tm :echo strftime("%l:%M %m/%d")<CR>

" Open a shell at the bottom of the screen
nnoremap <leader>sh :20new term://bash \| file bash \| startinsert<CR>

" Add/toggle checkboxes
" TODO: Make repeatable, work in visual mode, use one command for add/toggle
" TODO: Confine to Markdown
" Add after initial '-'
nnoremap <leader>cb ^wi[ ] <esc>2h
" Focus checkbox, toggle with 'x' or ' '
nnoremap <leader>ct ^f[lr

" Display tag list
nnoremap <leader>tb :TagbarToggle<CR>
nnoremap <leader>tc :TagbarCurrentTag f<CR>

" Faster file search
nmap gr <plug>(GrepperOperator)
xmap gr <plug>(GrepperOperator)

nnoremap <leader>gr :Grepper<cr>
nnoremap <leader>gs :Grepper -side<cr>
nnoremap <leader>gd :Grepper -dir file<cr>
nnoremap <leader>gw :Grepper -cword -noprompt<cr>
nnoremap <leader>gg :Grepper -tool git<cr>
nnoremap <leader>gf :Grepper -query '<c-r>=expand("%:t")<cr>'

" Fuzzy find files, buffers, commands, functions, classes, etc.
nnoremap <c-p><c-f> :Files<CR>
nnoremap <c-p><c-b> :Buffers<CR>
nnoremap <c-p><c-r> :History<CR>
nnoremap <c-p><c-h> :History:<CR>
nnoremap <c-p><c-t> :Tags<CR>

" }}}


" STATUS LINE {{{
" https://shapeshed.com/vim-statuslines/
" http://learnvimscriptthehardway.stevelosh.com/chapters/17.html
" TODO: Highlighting
" TODO: Max widths
" TODO: Whitespace/Indent warning
" TODO: http://vim.wikia.com/wiki/Display_date-and-time_on_status_line

" path/to/file[+]
set statusline=\ %.30f%m
" set statusline+=%{tagbar#currenttag(':%s','','f')}
" ~/c/w/dir
set statusline+=\ %#LineNR#
set statusline+=\ %{pathshorten(fnamemodify(getcwd(),':~'))}
" [master][venv]
set statusline+=\ %{GitHead()}%{VenvName()}
" [Help][Preview][Quickfix List][RO]
set statusline+=%h%w%q%r
" Right aligned
set statusline+=%=
" [vim]
set statusline+=%y
" [utf-8]
set statusline+=[%{&fileencoding?&fileencoding:&encoding}]
" [unix]
set statusline+=[%{&fileformat}]
" % Line Column
set statusline+=\ %#StatusLineNC#
set statusline+=\ %P\ %4l\ %3c
set statusline+=\ 

function! GitHead()
    let head = fugitive#head(6)
    return strlen(head) ? '[' . head . ']' : ''
endfunction

function! VenvName()
    let venv = virtualenv#statusline()
    return strlen(venv) ? '[' . venv . ']' : ''
endfunction

set noruler

" }}}
