let g:python_host_prog = expand('~/.virtualenvs/neovim2/bin/python')
let g:python3_host_prog = expand('~/.virtualenvs/neovim3/bin/python')

" PLUGINS {{{

call plug#begin('~/.local/share/nvim/plugged')

" Fuzzy file finder
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Smarter use of '.' with plugins
Plug 'tpope/vim-repeat'

" Insert/change/delete surrounding text pairs
Plug 'tpope/vim-surround'

" Handy '[' ']' shortcuts and toggles
Plug 'tpope/vim-unimpaired'

" Comment stuff out
Plug 'tpope/vim-commentary'

" Find and subsitute word (eg., case) variations
Plug 'tpope/vim-abolish'

" Unix shell commands (:Remove, :Rename, etc.)
Plug 'tpope/vim-eunuch'

" Git commands
Plug 'tpope/vim-fugitive'

" Git diff status in gutter
Plug 'airblade/vim-gitgutter'
let g:gitgutter_sign_column_always = 1

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
Plug 'davidhalter/jedi-vim'
let g:jedi#show_call_signatures = 2
let g:jedi#popup_on_dot = 0
let g:jedi#smart_auto_mappings = 0

" Fast HTML generation
Plug 'mattn/emmet-vim'

" Better Markdown experience
Plug 'reedes/vim-pencil'
let g:pencil#wrapModeDefault = 'soft'
let g:pencil#conceallevel = 0

" Asynchronous build and test dispatcher
Plug 'tpope/vim-dispatch'

" Interact with tmux
Plug 'benmills/vimux'

" Run tests for multiple languages using different strategies
Plug 'janko-m/vim-test'

" Quick Google lookup
Plug 'szw/vim-g'

" Updated versions of Solarized
Plug 'BlackIkeEagle/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'

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

set relativenumber

set expandtab tabstop=4 shiftwidth=4 softtabstop=4

set splitright splitbelow

" Configure completion
" set omnifunc=syntaxcomplete#Complete
" set complete=.,w,b,u
set completeopt-=preview

" Highlight textwidth to avoid long lines
set textwidth=80
set colorcolumn=+1

let g:netrw_bufsettings = "noma nomod nobl nowrap ro rnu"

" TODO Understand true color support for iTerm2 and tmux
" let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" set termguicolors
" colorscheme solarized8_dark
set background=dark
colorscheme solarized

" }}}


" AUTOCOMMANDS {{{

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  " autocmd FileType text call pencil#init({'wrap': 'hard'})
augroup END

" TODO: When this gets big, consider moving to after/ftplugin/<filetype>.vim
augroup filetypes
    autocmd!
    autocmd FileType help setlocal relativenumber
    autocmd FileType vim setlocal foldmethod=marker foldlevel=1
    autocmd FileType vim setlocal keywordprg=:help
    autocmd FileType crontab setlocal nobackup nowritebackup
    autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2
    autocmd FileType htmldjango setlocal commentstring={#\ %s\ #}
    autocmd BufNewFile,BufRead Vagrantfile set filetype=ruby
    autocmd BufNewFile,BufRead .babelrc set filetype=json
    autocmd BufNewFile,BufRead .bash* set filetype=sh
augroup END

" TODO: When this gets big, consider using sourced files or localvimrc
augroup code_es
    autocmd!
    autocmd BufNewFile,BufRead ~/Code/es/* setlocal
                \ textwidth=119
                \ wildignore+=*.css
    " TODO: Try ftdetect based on parent directory
    autocmd BufNewFile,BufRead ~/Code/es/*.html set filetype=htmldjango
    autocmd BufNewFile,BufRead ~/Code/es/*.txt set filetype=django
augroup END

" Assume tmux pane is in the right directory (e.g., on a virtual machine)
function! VimuxRawStrategy(cmd)
    call VimuxRunCommand(a:cmd)
endfunction
let g:test#custom_strategies = {'vimux_raw': function('VimuxRawStrategy')}

" TODO: Generalize this by moving ssh_command to server and using ./.ssh_config
function! EsSiteTransform(cmd) abort
    let ssh_command = 'source ~/venv/bin/activate; cd es-site/es'
    return 'ssh -t es.local '.shellescape(ssh_command.'; '.a:cmd)
endfunction
let g:test#custom_transformations = {'es-site': function('EsSiteTransform')}

augroup test_es
    " TODO: Use dispatch to populate quickfix window
    autocmd BufNewFile,BufRead ~/Code/es/*.py
                \ let g:test#strategy = 'vimux' |
                \ let g:test#transformation = 'es-site' |
                \ let g:test#filename_modifier = ':p:s?.*es-site/es/??' |
                \ let g:test#python#runner = 'djangotest' |
                \ let g:test#python#djangotest#executable = 'python -Wignore manage.py test' |
                \ let g:test#python#djangotest#options = '-k'
augroup END

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
cabbrev ph <c-r>=expand("%:p:h")<CR>

" Monday, November 28, 2016
iabbrev <expr> dt strftime("%A, %B %d, %Y")
cabbrev <expr> dt strftime("%Y-%m-%d")

" 15:14
iabbrev <expr> tm strftime("%H:%M")

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

" Display tag list
noremap <leader>tb :TagbarToggle<CR>
noremap <leader>tc :TagbarCurrentTag f<CR>

" Run commands in tmux
map <Leader>vp :VimuxPromptCommand<CR>
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vz :VimuxZoomRunner<CR>
map <Leader>vi :VimuxInspectRunner<CR>
map <Leader>vq :VimuxCloseRunner<CR>

" Fuzzy find files, buffers, commands, functions, classes, etc.
nnoremap <c-p><c-f> :Files<CR>
nnoremap <c-p><c-b> :Buffers<CR>
nnoremap <c-p><c-r> :History<CR>
nnoremap <c-p><c-h> :History:<CR>
nnoremap <c-p><c-t> :Tags<CR>

" Search for typed text
nnoremap <leader>ag :Rg<space>

" Search for word under cursor
nnoremap <leader>aw :Rg <c-r><c-w>

" Search for unnamed register after stripping whitespace and escaping characters
" TODO Make this a function, escape more chars
nnoremap <leader>a" :Rg <c-r>=substitute(getreg('"'),
            \'^\s*\(.\{-}\)\_s*$', '\=escape(submatch(1), ".()\\")', 'g')
            \<CR>

" Search for visual selection via unnamed register
" TODO Use vnoremap when unnamed search is made into a function
vmap <leader>ag y<leader>a"

" Use ripgrep for file search (from `:h fzf`)
command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \ 'rg --sort-files --column --line-number --no-heading --color=always --hidden '
            \ . shellescape(<q-args>),
            \ 1,
            \ <bang>0 ? fzf#vim#with_preview('up:60%')
            \         : fzf#vim#with_preview('right:50%:hidden', '?'),
            \ <bang>0)

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
" ~/path/to/cwd
set statusline+=\ %#LineNR#
set statusline+=\ %{pathshorten(fnamemodify(getcwd(),':~'))}
" [Git(master)]
set statusline+=\ %{GitHead()}
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
    return strlen(head) ? '(' . head . ')' : ''
endfunction

set noruler

" }}}
