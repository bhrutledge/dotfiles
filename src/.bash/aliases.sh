alias ls="ls -h"
alias grep='grep --color=auto'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias datestamp='date "+%Y%m%d"'
alias timestamp='date "+%Y%m%d-%H%M%S"'
alias tcopy='tee >(pbcopy)'
alias cat='bat --style plain'

# https://github.com/julienXX/terminal-notifier
# TODO: notify last command name
alias notify='terminal-notifier -sound default -message'

function hashable {
    hash "$@" 2> /dev/null
}

# Autocompletion for git aliases

function _git_since {
    _git_log
}

function _git_history {
    _git_log
}

function _git_files {
    _git_diff
}
