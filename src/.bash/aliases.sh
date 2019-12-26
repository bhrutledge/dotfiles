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
