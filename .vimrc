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
set complete-=i
set display=lastline
set encoding=utf-8
set formatoptions=tcqj
set history=10000
set hlsearch
set incsearch
set laststatus=2
set listchars=tab:>\ ,trail:-,nbsp:+
set mouse=a
set nrformats=hex
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

set number
" set signcolumn=yes
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
set textwidth=79
" set colorcolumn=+1
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


" MAPPINGS {{{

" Reload vimrc, refresh buffer to trigger autocmds
nnoremap <leader>sv :source $MYVIMRC \| edit<CR>

" Refresh syntax highlighting
nnoremap <leader>ss :syntax sync fromstart<CR>

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

" Friendlier grep: don't jump, show quickfix instead of full screen output
command! -nargs=+ Grep execute 'silent grep! <args>' | redraw! | cwindow

command! Marked execute 'silent !open -a "Marked 2.app" %' | redraw!

if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
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
set statusline+=\ %P\ %4l\ %3c
set statusline+=\ 

set noruler

" }}}


" AUTOCOMMANDS {{{

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
augroup END

" }}}


" https://github.com/direnv/direnv/wiki/Vim
if exists('$EXTRA_VIMRC')
    for path in split($EXTRA_VIMRC, ':')
        exec 'source '.path
    endfor
endif
