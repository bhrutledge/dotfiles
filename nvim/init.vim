" TODO: Create if missing
let g:python_host_prog = expand('~/.virtualenvs/neovim2/bin/python')
let g:python3_host_prog = expand('~/.virtualenvs/neovim3/bin/python')

" PLUGINS {{{
" TODO: Move plugin-specific mappings here?

" TODO: Variable for install location, for shared Vim 8 config
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    echo "Installing vim-plug..."
    !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.local/share/nvim/site/plugged')

" Fuzzy file finder
" TODO: Improve installation
Plug 'junegunn/fzf', { 'dir': '~/.local/share/nvim/site/fzf', 'do': './install --bin' }
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

" Git diff status in sign column
Plug 'airblade/vim-gitgutter'
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

" Syntax highlighting for many languages
" Note: Individual plugins might be missing features
Plug 'sheerun/vim-polyglot'
" https://github.com/sheerun/vim-polyglot/issues/209
" https://github.com/sheerun/vim-polyglot/issues/152
let g:polyglot_disabled = ['python', 'markdown']
" https://github.com/sheerun/vim-polyglot/issues/162
let g:jsx_ext_required = 1

" Python syntax
let python_highlight_all = 1
Plug 'Vimjas/vim-python-pep8-indent'

" Markdown syntax
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 0

Plug 'hail2u/vim-css3-syntax'

" Fast HTML generation
Plug 'mattn/emmet-vim'

" Asynchronous Lint Engine
Plug 'w0rp/ale'
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_fixers = {
            \   'javascript': [ 'eslint', 'remove_trailing_lines', 'trim_whitespace' ],
            \}

" Asynchronous completion
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'zchee/deoplete-jedi'
" Plug 'carlitux/deoplete-ternjs'
" " TODO: https://github.com/Shougo/deoplete.nvim/wiki/Completion-Sources
" let g:deoplete#enable_at_startup = 1

" Omni completion
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plug 'davidhalter/jedi-vim'
let g:jedi#show_call_signatures = 0
let g:jedi#popup_on_dot = 0
let g:jedi#smart_auto_mappings = 0

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
set linebreak

" Set terminal title: file.txt + (~/p/t/dir)
" TODO: Maybe file.txt + ($PWD)?
set title titlestring=%t%(\ %M%)%(\ (%{pathshorten(expand('%:~:h'))})%)

set completeopt=longest,menuone

let g:netrw_bufsettings = "noma nomod nobl nowrap ro rnu"
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_winsize = -40

" }}}


" AUTOCOMMANDS {{{

augroup startup
    autocmd!
    " TODO: Progress meter or install report
    autocmd VimEnter *
                \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) && confirm('Install missing plugins?')
                \|   PlugInstall --sync | q
                \| endif
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
    autocmd TermOpen * setlocal relativenumber signcolumn=no
augroup END

" TODO: When this gets big, consider using sourced files or localvimrc
augroup code_es
    autocmd!
    autocmd BufNewFile,BufRead */Code/{es,es-*}/* setlocal textwidth=119
    " TODO: Try ftdetect based on parent directory
    autocmd BufNewFile,BufRead ~/Code/es/*.html set filetype=htmldjango
    autocmd BufNewFile,BufRead ~/Code/es/*.txt set filetype=django
augroup END

augroup test_es
    " TODO: Use dispatch to populate quickfix window
    autocmd BufNewFile,BufRead ~/Code/es/*.py
                \ let g:test#filename_modifier = ':p:s?.*es-site/es/??' |
                \ let g:test#python#runner = 'djangotest' |
                \ let g:test#python#djangotest#executable = 'django-admin test' |
                \ let g:test#python#djangotest#options = '-k --settings es.settings.local_dev'
augroup END

" }}}


" MAPPINGS {{{

" Reload vimrc, refresh buffer to trigger autocmds
nnoremap <leader>sv :source $MYVIMRC \| edit<CR>

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

" Clear search (see unimpaired for `:set hlsearch` toggles)
nnoremap <silent> <leader>/ :let @/=''<CR>

" Set working directory to current file directory
nnoremap <leader>ch :lcd %:p:h<CR>

" Insert current file name/path/directory
" TODO: These might not be necessary; the expand args might be sufficient
cnoremap ;t <c-r>=expand("%:t")<CR>
cnoremap ;p <c-r>=expand("%:p")<CR>
cnoremap ;h <c-r>=expand("%:p:h")<CR>/
cnoremap ;H <c-r>=expand("%:.:h")<CR>/

" Yank current file name/path/directory
" TODO: Use a single map that takes expand args
nnoremap <leader>yf :let @"=@% \| echo @"<CR>
nnoremap <leader>yt :let @"=expand("%:t") \| echo @"<CR>
nnoremap <leader>yp :let @"=expand("%:p") \| echo @"<CR>
nnoremap <leader>yh :let @"=expand("%:p:h") \| echo @"<CR>
nnoremap <leader>yH :let @"=expand("%:.:h") \| echo @"<CR>

" Copy unnamed register to clipboard
" TODO: echo first X chars
nnoremap <leader>cy :let @+=@"<CR>

" Open vertical windows
nnoremap <leader>v :vertical<space>

" Display current time and date
nnoremap <leader>td :echo strftime("%l:%M %m/%d")<CR>

" Open a shell at the bottom of the screen
" TODO: Handle differences with Vim 8's :terminal
nnoremap <leader>sh :botright 20new \| terminal<CR>

" Jump between linter warnings (similar to unimpaired)
nmap <silent> [W <Plug>(ale_first)
nmap <silent> [w <Plug>(ale_previous)
nmap <silent> ]w <Plug>(ale_next)
nmap <silent> ]W <Plug>(ale_last)

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

" Z - cd to recent / frequent directories
" https://github.com/clvv/fasd/wiki/Vim-Integration
" TODO: Use FZF. Or just rely on CDPATH.
command! -nargs=* Z :call Z(<f-args>)
function! Z(...)
    let cmd = 'fasd -d -e printf'
    for arg in a:000
        let cmd = cmd . ' ' . arg
    endfor
    let path = system(cmd)
    if isdirectory(path)
        echo path
        exec 'lcd' fnameescape(path)
    endif
endfunction

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
" ~/c/w/dir
set statusline+=\ %#LineNR#
set statusline+=\ %{pathshorten(fnamemodify(getcwd(),':~'))}
" [master][venv]
set statusline+=\ %{GitHead()}%{VenvName()}
" [Help][Preview][Quickfix List][RO]
set statusline+=%h%w%q%r
" Right aligned
set statusline+=%=
" [5W 3E]
set statusline+=%{LinterStatus()}
" [filetype]
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
    let venv = fnamemodify($VIRTUAL_ENV, ':t')
    return strlen(venv) ? '[' . venv . ']' : ''
endfunction

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? '' : printf('[%dW %dE]', all_non_errors, all_errors)
endfunction

set noruler

" }}}


" COLOR SCHEME {{{

set background=dark

if exists('$ITERM_PROFILE')
    set termguicolors
endif

" colorscheme solarized
" colorscheme solarized8_dark
colorscheme NeoSolarized

highlight! link TermCursor Cursor
highlight! link TermCursorNC Search

" }}}
