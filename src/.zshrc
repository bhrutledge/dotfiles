# region SETUP

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Accessing-On_002dLine-Help
HELPDIR=/usr/share/zsh/$ZSH_VERSION/help
autoload -Uz run-help

# endregion

# region PROMPT

# http://zsh.sourceforge.net/Doc/Release/Functions.html#Hook-Functions
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Manipulating-Hook-Functions

autoload -Uz add-zsh-hook

br() { print "" }
add-zsh-hook precmd br

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source $(brew --prefix git)/etc/bash_completion.d/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWUPSTREAM='verbose'
GIT_PS1_DESCRIBE_STYLE='branch'

# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
setopt PROMPT_SUBST
PROMPT='%F{yellow}%~%f$(__git_ps1 " (%s)")%(?.. %F{red}%?%f)
%# '

export CLICOLOR=1

# endregion

# region COMPLETION
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
# http://zsh.sourceforge.net/Doc/Release/Completion-System.html
# https://github.com/zsh-users/zsh-completions

FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

zstyle ':completion:*' menu select
autoload -Uz compinit && compinit

# endregion

# region HISTORY
# http://zsh.sourceforge.net/Doc/Release/Options.html#History
# https://www.soberkoder.com/better-zsh-history/

HISTSIZE=10000000
SAVEHIST=10000000

setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY_TIME
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# endregion

# region ALIASES

alias ls="ls -h"
alias grep='grep --color=auto'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias datestamp='date "+%Y%m%d"'
alias timestamp='date "+%Y%m%d-%H%M%S"'
alias notify='terminal-notifier -sound default -message'
alias cat='bat --style plain'

# endregion

# region PATH
# Using PATH_SET to avoid duplicate entries

if [[ ! -v PATH_SET ]]; then
    eval "$(pyenv init -)"
    eval "$(nodenv init -)"
    eval "$(rbenv init -)"

    export PATH_SET=1
fi

# endregion
