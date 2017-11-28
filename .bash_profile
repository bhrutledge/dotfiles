echo -n .bash_profile\ 

export PATH=$HOME/bin:$HOME/.local/bin:$PATH
export CDPATH="$HOME:$HOME/Code:$CDPATH"
export PAGER='less'

if hash nvim 2> /dev/null; then
    echo -n nvim\ 
    export EDITOR='nvim'
else
    export EDITOR='vim'
fi

export VISUAL=$EDITOR

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Code

if hash rg 2> /dev/null; then
    echo -n rg\ 
    export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'
elif hash ag 2> /dev/null; then
    echo -n ag\ 
    export FZF_DEFAULT_COMMAND='ag -g ""'
fi

if [ -f ~/.bash_exports ]; then
    source ~/.bash_exports
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
