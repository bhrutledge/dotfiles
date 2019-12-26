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

bold=$(tput bold)
dim=$(tput dim)

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
export LESS_TERMCAP_mb=$dim$red
export LESS_TERMCAP_md=$bold$red
export LESS_TERMCAP_us=$bold$green
export LESS_TERMCAP_ue=$reset

# http://geoff.greer.fm/lscolors/
export CLICOLOR=1
export LSCOLORS='exfxcxdxbxegedabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
