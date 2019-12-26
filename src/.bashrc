echo -n .bashrc\ 

# Abort for non-interactive shells
if [ -z "$PS1" ]; then
    echo
    return
fi


## MISC SETTINGS

shopt -s direxpand


## ALIASES

alias ls="ls -h"
alias grep='grep --color=auto'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias exl='exa -lhb --time-style long-iso'
alias datestamp='date "+%Y%m%d"'
alias timestamp='date "+%Y%m%d-%H%M%S"'

# https://github.com/julienXX/terminal-notifier
# TODO: notify last command name
alias notify='terminal-notifier -sound default -message'


## FUNCTIONS

function parentdir {
    local dir=${1:-$PWD}

    dir=${dir/#$HOME/\~}
    echo ${dir%/*}
}

function shortdir {
    local dir=${1:-$PWD}

    # TODO: Eliminate this special case
    if [ "$dir" = "$HOME" ]; then
        echo '~';
        return
    fi

    local parent=$(parentdir "$dir" | sed -e "s;\(/.\)[^/]*;\1;g")
    local base=${dir##*/}
    echo $parent/$base
}

# List processes listening on TCP ports
# TODO: Add args for sudo, port, and command
function ltcp {
    sudo lsof -Pn -i4TCP -sTCP:LISTEN -F pn | \
    while read line
    do
        [[ $line =~ ^p ]] && echo && ps -o pid,command -p ${line#p} | tail -n1
        [[ $line =~ ^n ]] && echo ${line#n}
    done
}

[ -f ~/.bash_aliases ] && source ~/.bash_aliases


## COLORS
# http://wiki.bash-hackers.org/scripting/terminalcodes

# TODO: Fallback for missing tput?
# TODO: Use `fg` and `bg` array variables
reset=$(tput sgr0)

black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

bg_black=$(tput setab 0)
bg_red=$(tput setab 1)
bg_green=$(tput setab 2)
bg_yellow=$(tput setab 3)
bg_blue=$(tput setab 4)
bg_magenta=$(tput setab 5)
bg_cyan=$(tput setab 6)
bg_white=$(tput setab 7)

bold=$(tput bold)
dim=$(tput dim)

# http://unix.stackexchange.com/questions/119/colors-in-man-pages
# http://unix.stackexchange.com/questions/108699/documentation-on-less-termcap-variables
# https://www.gnu.org/software/termutils/manual/termcap-1.3/html_node/termcap_33.html
#
# termcap terminfo
# me      sgr0     turn off bold, blink and underline
# mb      blink    start blink
# md      bold     start bold (bright)
# mr      rev      start reverse
# mh      dim      start dim (half-bright)
# so      smso     start standout
# se      rmso     stop standout
# us      smul     start underline
# ue      rmul     stop underline

export LESS_TERMCAP_me=$reset
export LESS_TERMCAP_mb=$dim$red
export LESS_TERMCAP_md=$bold$red
export LESS_TERMCAP_us=$bold$green
export LESS_TERMCAP_ue=$reset

# http://geoff.greer.fm/lscolors/
export CLICOLOR=1
export LSCOLORS='exfxcxdxbxegedabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'


## PROMPT

# TODO: Research TERM=[xterm|screen|gnome]-256color
# TODO: Understand why \[...\] isn't necessary around colors in functions

# Set terminal title to current directory, relative to $HOME
function __term_title ()
{
    echo -en "\033]0;$(shortdir)\a"
}

export VIRTUAL_ENV_DISABLE_PROMPT=1

function __venv_ps1 ()
{
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv=${VIRTUAL_ENV##*/}
        echo " (${venv})"
    fi
}

# user@hostname:~/current/dir (git status) (virtualenv)
# $

ps1_pre="\$(__term_title)"
ps1_pre+="\n\[$reset\]"
ps1_pre+="\[$magenta\]\u@\h\[$reset\]:"
ps1_pre+="\[$yellow\]\w\[$reset\]"

ps1_post="\$(__venv_ps1)\n\[$white\]\\$\[$reset\] "

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
# Could be sourced from bash-completion, but that's not reliable
# TODO: Look for this in common git install locations
if [ -r ~/.git-prompt.sh ]; then
    echo -n git_ps1\ 
    source ~/.git-prompt.sh

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


## HISTORY

HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL='ignorespace'

shopt -s histappend
shopt -s cmdhist

# Save history between sessions; add "; history -c; history -r" to sync
PROMPT_COMMAND+="; history -a"

## SERVICES

# Assuming `brew install bash-completion@2`
# TODO: Locate on Ubuntu, CentOS
if [ -r "/usr/local/etc/profile.d/bash_completion.sh" ]; then
    echo -n bash_completion\ 
    BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
    source "/usr/local/etc/profile.d/bash_completion.sh"
fi

if hash fasd 2> /dev/null; then
    echo -n fasd\ 
    eval "$(fasd --init auto)"
fi

if hash direnv 2> /dev/null; then
    echo -n direnv\ 
    eval "$(direnv hook bash)"
fi

if hash fzf 2> /dev/null; then
    echo -n fzf\ 
    # source /usr/local/opt/fzf/shell/completion.bash
    # source /usr/local/opt/fzf/shell/key-bindings.bash

    # https://github.com/junegunn/fzf/wiki/Examples

    # fe [FUZZY PATTERN] - Open the selected file with the default editor
    #   - Bypass fuzzy finder if there's only one match (--select-1)
    #   - Exit if there's no match (--exit-0)
    # TODO: Add option for `open`
    fe() {
        local files
        IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
        [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
    }

    # fuzzy grep open via ripgrep
    # TODO: Interactive prompt
    fge() {
        local file
        file="$(rg --no-heading $@ | fzf --tac -0 -1)"
        [[ -n $file ]] && ${EDITOR:-vim} $file
    }

    # checkout git branch
    fco() {
        local branches branch
        branches=$(git branch -vv) &&
            branch=$(echo "$branches" | fzf --query="$1" +m) &&
            git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
    }

    # cd to selected directory
    fcd() {
        local dir
        # TODO: Use `fd`, esp. for ignoring
        dir=$(find ${1:-.} -path '*/\.*' -prune \
            -o -type d -print 2> /dev/null | fzf +m) &&
            cd "$dir"

        # TODO: Add option for parent dirs
    }

    # Fuzzy `z` from fasd
    fz() {
        local dir
        dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
    }
fi

echo
