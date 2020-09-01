# TODO: Research TERM=[xterm|screen|gnome]-256color
# TODO: Understand why \[...\] isn't necessary around colors in functions

function __parentdir {
    local dir=${1:-$PWD}

    dir=${dir/#$HOME/\~}
    echo ${dir%/*}
}

function __shortdir {
    local dir=${1:-$PWD}

    # TODO: Eliminate this special case
    if [[ $dir = $HOME ]]; then
        echo '~';
        return
    fi

    local parent=$(__parentdir "$dir" | sed -e "s;\(/.\)[^/]*;\1;g")
    local base=${dir##*/}
    echo $parent/$base
}

# Set terminal title to current directory, relative to $HOME
function __term_title ()
{
    echo -en "\033]0;$(__shortdir)\a"
}

export VIRTUAL_ENV_DISABLE_PROMPT=1

function __venv_ps1 ()
{
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv=${VIRTUAL_ENV##*/}
        echo " (${venv})"
    fi
}

# user@hostname ~/current/dir (git status) (virtualenv)
# $

ps1_pre="\$(__term_title)"
ps1_pre+="\n\[$reset\]"
ps1_pre+="\[$magenta\]\u@\h\[$reset\] "
ps1_pre+="\[$yellow\]\w\[$reset\]"

ps1_post="\$(__venv_ps1)\n\[$white\]\\$\[$reset\] "

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
# Could be sourced from bash-completion, but that's not reliable
# TODO: Look for this in common git install locations
if [[ -r ~/.bash/git-prompt.sh ]]; then
    source ~/.bash/git-prompt.sh

    PROMPT_COMMAND="__git_ps1 \"$ps1_pre\" \"$ps1_post\""
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWCOLORHINTS=1
    GIT_PS1_SHOWUPSTREAM='verbose'
    GIT_PS1_DESCRIBE_STYLE='branch'
else
    PROMPT_COMMAND="PS1=\"${ps1_pre}${ps1_post}\""
fi

# Set a simple prompt for shell examples
function ps1 ()
{
    unset PROMPT_COMMAND
    PS1="\n\$ "
}
