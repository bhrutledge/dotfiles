echo -n .bash_profile\ 

export PATH=$HOME/bin:$HOME/.local/bin:$PATH

export EDITOR='vim'
export VISUAL=$EDITOR
export PAGER='less'

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Code

if [ -f ~/.bash_exports ]; then
    source ~/.bash_exports
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
