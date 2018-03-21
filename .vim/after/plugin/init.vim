" TODO: General-purpose colorscheme/plugin test:w

if !empty(globpath(&rtp, 'colors/NeoSolarized.vim'))
    syntax enable
    set background=dark
    if exists('$ITERM_PROFILE')
        set termguicolors
    endif

    colorscheme NeoSolarized
endif

