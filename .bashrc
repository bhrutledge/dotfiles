echo .bashrc

if [ -f /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
fi

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi


## ALIASES

# http://stackoverflow.com/questions/1676426/how-to-check-the-ls-version
if ls --color -d . >/dev/null 2>&1; then
    color_flag='--color'
elif ls -G -d . >/dev/null 2>&1; then
    color_flag='-G'
fi

alias ls="command ls -h $color_flag"
alias grep='grep --color=auto'
alias mux='tmuxinator'
alias rm='rm -i'

eval "$(fasd --init auto)"

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

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
PROMPT_COMMAND="__git_ps1 \"$ps1_pre\" \"$ps1_post\""
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWUPSTREAM="verbose"
