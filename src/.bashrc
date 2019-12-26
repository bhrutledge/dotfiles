# Skip for non-interactive shells
if [[ $- != *i* ]]; then
    return
fi

# Only load this once (e.g., to avoid duplicate PATH)
if [[ $BASHRC ]]; then
    return
else
    export BASHRC=1
fi

## MISC SETTINGS ##

shopt -s direxpand

export PATH="$HOME/bin:$HOME/.local/bin::$PATH"
export CDPATH=".:$HOME:$HOME/Code"

export PAGER='less'
export EDITOR='code'
export VISUAL=$EDITOR

## MODULAR CONFIGURATION ##
# Order matters

source ~/.bash/aliases.sh
source ~/.bash/colors.sh
source ~/.bash/prompt.sh
source ~/.bash/history.sh

## SERVICES ##

if hashable pyenv; then
    echo -n pyenv\ 
    eval "$(pyenv init -)"
    if hashable pyenv-virtualenv-init; then
        eval "$(pyenv virtualenv-init -)"
    fi
fi

if hashable rbenv; then
    echo -n rbenv\ 
    eval "$(rbenv init -)"
fi


if hashable fasd; then
    echo -n fasd\ 
    eval "$(fasd --init auto)"
fi

if hashable direnv; then
    echo -n direnv\ 
    eval "$(direnv hook bash)"
fi

if hashable fzf; then
    echo -n fzf\ 
    source ~/.bash/fzf.sh
fi

# Assuming `brew install bash-completion@2`
# TODO: Locate on Ubuntu, CentOS
if [ -r "/usr/local/etc/profile.d/bash_completion.sh" ]; then
    echo -n bash_completion\ 
    BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
    source "/usr/local/etc/profile.d/bash_completion.sh"
fi

## LOCAL CONFIGURATION ##

if [[ -f ~/.bash_exports ]]; then
    source ~/.bash_exports
fi

if [[ -f ~/.bash_aliases ]]; then 
    source ~/.bash_aliases
fi
