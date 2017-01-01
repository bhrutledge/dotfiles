# TODO: Research TERM=[xterm|screen|gnome]-256color
# TODO: Move these to a general-purpose file
# TODO: Fallback for missing tput?
reset=$(tput sgr0)
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

# TODO: Terminal title
PS1="\n"

# user@hostname:
PS1+="\[$magenta\]\u@\h\[$reset\]:"

# ~/current/dir
PS1+="\[$green\]\w\[$reset\]"

#  (virtualenv)
function __venv_ps1 ()
{
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv=$(basename "$VIRTUAL_ENV")
        # TODO: Understand why \[...\] isn't necessary
        echo " (${blue}${venv}${reset})"
    fi
}
PS1+="\$(__venv_ps1)"
export VIRTUAL_ENV_DISABLE_PROMPT=1

#  (git status)
# TODO: Set GIT_PS1_* variables
# TODO: Use PROMPT_COMMAND for speed, colors
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
PS1+="\$(__git_ps1 ' (\[$cyan\]%s\[$reset\])')"
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1

# \n$
PS1+="\n\[$white\]\\$\[$reset\] "

export PS1
