HISTSIZE=10000
HISTFILESIZE=10000
HISTTIMEFORMAT="%F %T "
HISTIGNORE='[ ]*:exit:ls*:history*'

shopt -s cmdhist
shopt -s histappend

# Save commands immediately, instead of end of session
# Add "; history -c; history -r" to sync between sessions
PROMPT_COMMAND+="; history -a"
