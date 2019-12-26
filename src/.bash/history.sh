HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL='ignorespace'

shopt -s histappend
shopt -s cmdhist

# Save history between sessions; add "; history -c; history -r" to sync
PROMPT_COMMAND+="; history -a"
