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

" Syntax highlighting for many languages
" Note: Individual plugins might be missing features
Plug 'sheerun/vim-polyglot'

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
" set completeopt-=preview

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
augroup END

" TODO: When this gets big, consider using sourced files
augroup projects
    autocmd!
    autocmd BufNewFile,BufRead ~/Code/es/* setlocal
                \ textwidth=119
                \ wildignore+=*.css
    " TODO: Try ftdetect based on parent directory
    autocmd BufNewFile,BufRead ~/Code/es/*.html set filetype=htmldjango
    autocmd BufNewFile,BufRead ~/Code/es/*.txt set filetype=django
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
            \ 'rg --column --line-number --no-heading --color=always --hidden '
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
