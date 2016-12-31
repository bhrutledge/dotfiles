if ls --color -d . >/dev/null 2>&1; then
    colorflag='--color'
    # TODO: export LS_COLORS
elif ls -G -d . >/dev/null 2>&1; then
    colorflag='-G'
    # TODO: export LSCOLORS
fi

alias ls="command ls -h $colorflag"
