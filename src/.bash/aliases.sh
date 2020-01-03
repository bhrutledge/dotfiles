alias ls="ls -h"
alias grep='grep --color=auto'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias datestamp='date "+%Y%m%d"'
alias timestamp='date "+%Y%m%d-%H%M%S"'
alias tpb='tee >(pbcopy)'

# https://github.com/julienXX/terminal-notifier
# TODO: notify last command name
alias notify='terminal-notifier -sound default -message'

function hashable {
    hash "$@" 2> /dev/null
}
