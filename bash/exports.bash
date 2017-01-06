export PATH=$HOME/bin:$HOME/.local/bin:$PATH

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

export PROJECT_HOME=$HOME/Code

# Color variables
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

bg_black=$(tput setaf 0)
bg_red=$(tput setaf 1)
bg_green=$(tput setaf 2)
bg_yellow=$(tput setaf 3)
bg_blue=$(tput setaf 4)
bg_magenta=$(tput setaf 5)
bg_cyan=$(tput setaf 6)
bg_white=$(tput setaf 7)

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
