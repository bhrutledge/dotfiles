function echo_n {
    echo -n "$@ "
}

echo_n .bash_profile

export PATH=$HOME/bin:$HOME/.local/bin:$PATH

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

export PROJECT_HOME=$HOME/Code

if [ -f ~/.bash_exports ]; then
    source ~/.bash_exports
fi

if [[ -n $PS1 &&  -f ~/.bashrc ]]; then
    source ~/.bashrc
fi

echo
