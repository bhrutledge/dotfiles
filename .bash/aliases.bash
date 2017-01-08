# http://stackoverflow.com/questions/1676426/how-to-check-the-ls-version
if ls --color -d . >/dev/null 2>&1; then
    color_flag='--color'
elif ls -G -d . >/dev/null 2>&1; then
    color_flag='-G'
fi

alias ls="command ls -h $color_flag"

alias grep='grep --color=auto'
alias mux='tmuxinator'
