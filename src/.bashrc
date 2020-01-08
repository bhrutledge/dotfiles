# Set PATH for scripts and interactive shells
source ~/.bash/path.sh

# Skip the rest for scripts
if [[ $- != *i* ]]; then
    return
fi

## MISC CONFIGURATION ##

if [[ $TERM_PROGRAM == "vscode" ]]; then
    export EDITOR=code
else
    export EDITOR=vim
fi
export VISUAL=$EDITOR
export PAGER=less

## MODULAR CONFIGURATION ##
# Order matters

source ~/.bash/aliases.sh
source ~/.bash/colors.sh
source ~/.bash/prompt.sh
source ~/.bash/history.sh

## SERVICES ##

if hashable pyenv; then
    eval "$(pyenv init -)"
    if hashable pyenv-virtualenv-init; then
        eval "$(pyenv virtualenv-init -)"
    fi
fi

if hashable rbenv; then
    eval "$(rbenv init -)"
fi

if hashable fasd; then
    eval "$(fasd --init auto)"
fi

if hashable direnv; then
    eval "$(direnv hook bash)"
fi

if hashable fzf; then
    source ~/.bash/fzf.sh
fi

# Assuming `brew install bash-completion@2`
# TODO: Locate on Ubuntu, CentOS
if [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]]; then
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
