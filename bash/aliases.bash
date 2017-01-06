# http://stackoverflow.com/questions/1676426/how-to-check-the-ls-version
if ls --color -d . >/dev/null 2>&1; then
    colorflag='--color'
    # TODO: export LS_COLORS
elif ls -G -d . >/dev/null 2>&1; then
    colorflag='-G'
    # TODO: export LSCOLORS
fi

alias ls="command ls -h $colorflag"

alias grep='grep --color=auto'
alias mux='tmuxinator'
