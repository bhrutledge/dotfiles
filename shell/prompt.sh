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
ps1_pre="\n"

# user@hostname:
ps1_pre+="\[$magenta\]\u@\h\[$reset\]:"

# ~/current/dir
ps1_pre+="\[$cyan\]\w\[$reset\]"

#  (virtualenv)
function __venv_ps1 ()
{
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv=$(basename "$VIRTUAL_ENV")
        # TODO: Understand why \[...\] isn't necessary
        echo " (${blue}${venv}${reset})"
    fi
}
ps1_pre+="\$(__venv_ps1)"
export VIRTUAL_ENV_DISABLE_PROMPT=1

# \n$
ps1_post="\n\[$white\]\\$\[$reset\] "

#  (git status)
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
PROMPT_COMMAND="__git_ps1 \"$ps1_pre\" \"$ps1_post\""
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWCOLORHINTS=1
