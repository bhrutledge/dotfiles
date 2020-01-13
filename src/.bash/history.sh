HISTSIZE=10000
HISTFILESIZE=10000
HISTTIMEFORMAT="%F %T "
HISTIGNORE='[ ]*:exit:ls:history'

shopt -s cmdhist
shopt -s histappend

# Save commands immediately, instead of end of session, to avoid lost history
# This will interleave commands from multiple sessions
# PROMPT_COMMAND+="; history -a"
# Sync history between active sessions
# PROMPT_COMMAND+="; history -c; history -r"
