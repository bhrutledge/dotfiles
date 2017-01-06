# Colors defined in exports.sh
# TODO: Research TERM=[xterm|screen|gnome]-256color
# TODO: Understand why \[...\] isn't necessary around colors in functions

export VIRTUAL_ENV_DISABLE_PROMPT=1

function __venv_ps1 ()
{
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv=$(basename "$VIRTUAL_ENV")
        echo " (${venv})"
    fi
}

# user@hostname:~/current/dir (git status) (virtualenv)
# $

# TODO: Terminal title
ps1_pre="\n\[$reset\]"
ps1_pre+="\[$magenta\]\u@\h\[$reset\]:"
ps1_pre+="\[$cyan\]\w\[$reset\]"

ps1_post="\$(__venv_ps1)\n\[$white\]\\$\[$reset\] "

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
PROMPT_COMMAND="__git_ps1 \"$ps1_pre\" \"$ps1_post\""
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWUPSTREAM="verbose"
