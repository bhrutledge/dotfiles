" PLUGINS {{{

call plug#begin('~/.local/share/nvim/plugged')

" Fuzzy file finder
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Enhance netrw
Plug 'tpope/vim-vinegar'

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

" Syntax highlighting
" Note: Individual plugins might be missing features
Plug 'sheerun/vim-polyglot'

" Updated versions of Solarized
Plug 'BlackIkeEagle/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'

" TODO Super-charged status line
" Plug 'vim-airline/vim-airline'
Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ }

" Don't duplicate Insert/Replace/Visual with status line
set noshowmode

call plug#end()

" }}}


" SETTINGS {{{

" Search working directory, current file directory, and subdirectories
set path=.,,**

" TODO Pull from .gitignore and .ignore
set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildignore+=*.egg-info/**
set wildignore+=node_modules/**
set wildignore+=tags

set relativenumber

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set splitright
set splitbelow

" Highlight textwidth to avoid long lines
set textwidth=80
set colorcolumn=+1

" TODO Understand true color support for iTerm2 and tmux
" let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" set termguicolors
" colorscheme solarized8_dark
set background=dark
colorscheme solarized

" }}}


" MAPPINGS {{{

" Hide matches
nnoremap <leader>/ :nohlsearch<CR>

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

" Quickly search for files, functions, classes, etc.
nnoremap <c-p><c-f> :Files<CR>
nnoremap <c-p><c-b> :Buffers<CR>
nnoremap <c-p><c-r> :History<CR>
nnoremap <c-p><c-h> :History:<CR>
nnoremap <c-p><c-t> :Tags<CR>

" Search files in current directory

" TODO? Plug 'wincent/ferret'
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)

" TODO Add <CR>
nmap <leader>ag :Rg<space>
nmap <leader>aw :Rg <c-r><c-w>
" Search for unnamed register after stripping whitespace and escaping characters
" TODO Make this a function
" TODO Escape more chars
nmap <leader>a" :Rg <c-r>=substitute(getreg('"'),
            \'^\s*\(.\{-}\)\_s*$', '\=escape(submatch(1), ".()\\")', 'g')
            \<CR>
" Yank and search for visual selection
vmap <leader>a y<leader>a"

" }}}


" Project-specific settings
" TODO: More robust solution, that considers parent directories. Consider $XDG_CONFIG_DIRS.
if filereadable('.lvimrc')
    source .lvimrc
endif
