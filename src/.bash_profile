echo -n .bash_profile\ 

export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/sbin:$PATH"
export PAGER='less'

[ -z "$PS1" ] || export CDPATH=".:$HOME:$HOME/Code"

export EDITOR='vim'
export VISUAL=$EDITOR

if hash rg 2> /dev/null; then
    echo -n rg\ 
    export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'
elif hash ag 2> /dev/null; then
    echo -n ag\ 
    export FZF_DEFAULT_COMMAND='ag -g ""'
fi

if hash fd 2> /dev/null; then
    echo -n fd\ 
    # https://github.com/sharkdp/fd/blob/master/README.md#using-fd-with-fzf
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
fi

if hash pyenv 2>/dev/null; then
    echo -n pyenv\ 
    eval "$(pyenv init -)"
    if hash pyenv-virtualenv-init 2> /dev/null; then
        eval "$(pyenv virtualenv-init -)"
    fi
fi

[ -f ~/.cargo/env ] && source ~/.cargo/env
[ -f ~/.bash_exports ] && source ~/.bash_exports
[ -f ~/.bashrc ] && source ~/.bashrc
