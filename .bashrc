echo -n .bashrc\ 


## ALIASES

# http://stackoverflow.com/questions/1676426/how-to-check-the-ls-version
if ls --color -d . >/dev/null 2>&1; then
    color_flag='--color'
elif ls -G -d . >/dev/null 2>&1; then
    color_flag='-G'
fi

alias ls="command ls -h $color_flag"
alias grep='grep --color=auto'
alias rm='rm -i'

# Lightweight replacements for virtualenvwrapper
# TODO: Error handling
# TODO: Completion

function workon {
    source $WORKON_HOME/$1/bin/activate

    if [ -d $PROJECT_HOME/$1 ]; then
        cd $PROJECT_HOME/$1
    fi
}

function cdproject {
    cd $PROJECT_HOME/$(basename $VIRTUAL_ENV)
}

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi


## COLORS
# http://wiki.bash-hackers.org/scripting/terminalcodes

# TODO: Fallback for missing tput?
# TODO: Use `fg` and `bg` array variables
reset=$(tput sgr0)

black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

bg_black=$(tput setab 0)
bg_red=$(tput setab 1)
bg_green=$(tput setab 2)
bg_yellow=$(tput setab 3)
bg_blue=$(tput setab 4)
bg_magenta=$(tput setab 5)
bg_cyan=$(tput setab 6)
bg_white=$(tput setab 7)

# http://unix.stackexchange.com/questions/119/colors-in-man-pages
# http://unix.stackexchange.com/questions/108699/documentation-on-less-termcap-variables
# https://www.gnu.org/software/termutils/manual/termcap-1.3/html_node/termcap_33.html
#
# termcap terminfo
# me      sgr0     turn off bold, blink and underline
# mb      blink    start blink
# md      bold     start bold (bright)
# mr      rev      start reverse
# mh      dim      start dim (half-bright)
# so      smso     start standout
# se      rmso     stop standout
# us      smul     start underline
# ue      rmul     stop underline

export LESS_TERMCAP_me=$reset
export LESS_TERMCAP_mb=$(tput dim)$red
export LESS_TERMCAP_md=$(tput bold)$red
export LESS_TERMCAP_us=$(tput bold)$green
export LESS_TERMCAP_ue=$reset

# http://geoff.greer.fm/lscolors/
export LSCOLORS='exfxcxdxbxegedabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'


## PROMPT

# TODO: Research TERM=[xterm|screen|gnome]-256color
# TODO: Understand why \[...\] isn't necessary around colors in functions

export VIRTUAL_ENV_DISABLE_PROMPT=1

function __venv_ps1 ()
{
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv=$(basename "$VIRTUAL_ENV")
        echo " (${venv})"
    fi
}

# user@hostname:~/current/dir (git status) (virtualenv)
# $

# TODO: Terminal title
ps1_pre="\n\[$reset\]"
ps1_pre+="\[$magenta\]\u@\h\[$reset\]:"
ps1_pre+="\[$yellow\]\w\[$reset\]"

ps1_post="\$(__venv_ps1)\n\[$white\]\\$\[$reset\] "

# This might also be included in the git distribution
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
if [ -f ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
fi

PROMPT_COMMAND="__git_ps1 \"$ps1_pre\" \"$ps1_post\""
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWUPSTREAM='verbose'
GIT_PS1_DESCRIBE_STYLE='branch'


## HISTORY

HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL='ignorespace'

shopt -s histappend
shopt -s cmdhist

# Save history between sessions; add "; history -c; history -r" to sync
PROMPT_COMMAND+="; history -a"


## SERVICES

# TODO: Locate on Ubuntu, CentOS
if [ -f /usr/local/etc/bash_completion ]; then
    echo -n bash_completion\ 
    source /usr/local/etc/bash_completion
fi

if hash fasd 2> /dev/null; then
    echo -n fasd\ 
    eval "$(fasd --init auto)"
fi

if hash direnv 2> /dev/null; then
    echo -n direnv\ 
    eval "$(direnv hook bash)"
    # https://github.com/direnv/direnv/wiki/Tmux
    # https://github.com/direnv/direnv/issues/106
    alias tmux='direnv exec / tmux'
    alias mux='direnv exec / tmuxinator'
fi

if hash fzf 2> /dev/null; then
    echo -n fzf\ 
    # source /usr/local/opt/fzf/shell/completion.bash
    # source /usr/local/opt/fzf/shell/key-bindings.bash

    if hash rg 2> /dev/null; then
        echo -n rg\ 
        export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'
    elif hash ag 2> /dev/null; then
        echo -n ag\ 
        export FZF_DEFAULT_COMMAND='ag -g ""'
    fi

    # checkout git branch
    fco() {
        local branches branch
        branches=$(git branch -vv) &&
            branch=$(echo "$branches" | fzf +m) &&
            git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
    }
fi

if hash nvim 2> /dev/null; then
    echo -n nvim\ 
    alias vim='nvim'
    alias vimdiff='nvim -d'
    export EDITOR='nvim'
    export VISUAL='nvim'
fi
