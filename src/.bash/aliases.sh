# shellcheck shell=bash
alias ls="ls -h"
alias grep='grep --color=auto'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias datestamp='date "+%Y%m%d"'
alias timestamp='date "+%Y%m%d-%H%M%S"'
alias clip='tee >(pbcopy)'
alias cat='bat --style plain'
alias pip="PIP_REQUIRE_VIRTUALENV=1 pip"
# https://unix.stackexchange.com/a/282384
alias inbox=": | vipe | sed -e '/^$/d; s/^/- /' >> /Users/brian/Dropbox/LFTM/inbox.md"

# https://github.com/julienXX/terminal-notifier
# TODO: notify last command name
alias notify='terminal-notifier -sound default -message'

# Autocompletion for git aliases

function _git_since {
    _git_log
}

function _git_hist {
    _git_log
}

function _git_files {
    _git_diff
}
