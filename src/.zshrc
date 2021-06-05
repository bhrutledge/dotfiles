# region SETUP

# https://zsh.sourceforge.io/Doc/Release/Options.html
unsetopt BEEP
unsetopt FLOW_CONTROL

# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Accessing-On_002dLine-Help
HELPDIR=/usr/share/zsh/$ZSH_VERSION/help
autoload -Uz run-help
unalias run-help 2>/dev/null

# http://geoff.greer.fm/lscolors/
export CLICOLOR=1
export LSCOLORS='exfxcxdxbxegedabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# endregion

# region PROMPT

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source $(brew --prefix git)/etc/bash_completion.d/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWUPSTREAM='verbose'
GIT_PS1_DESCRIBE_STYLE='branch'

# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
# https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion
setopt PROMPT_SUBST
PROMPT='
'
PROMPT+='${SSH_CLIENT+"%F{magenta}%m%f:"}'
PROMPT+='%B%F{blue}%~%f%b'
PROMPT+='$(__git_ps1 " (%s)")'
export VIRTUAL_ENV_DISABLE_PROMPT=1
PROMPT+='${VIRTUAL_ENV+ (${VIRTUAL_ENV:t})}'
PROMPT+='%(?.. %F{red}%?%f)'
PROMPT+='
%# '

# endregion

# region COMPLETION
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
# https://zsh.sourceforge.io/Doc/Release/Completion-System.html
# https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#The-zsh_002fcomplist-Module
# https://zsh.sourceforge.io/Doc/Release/Options.html#Completion-4
# https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Completion
# https://github.com/zsh-users/zsh-completions

FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

# zstyle ':completion:*' format '%F{8}completing %d%f'
# zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt ''
# setopt MENU_COMPLETE

autoload -Uz compinit
compinit

# https://zsh.sourceforge.io/Doc/Release/Options.html#Changing-Directories
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Recent-Directories
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 100

# endregion

# region HISTORY
# https://zsh.sourceforge.io/Doc/Release/Options.html#History
# https://zsh.sourceforge.io/Doc/Release/Expansion.html#History-Expansion
# https://www.soberkoder.com/better-zsh-history/

HISTSIZE=10000000
SAVEHIST=10000000

setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY_TIME
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# endregion

# region LINE EDITING
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#ZLE-Functions
# https://zsh.sourceforge.io/Guide/zshguide04.html

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
autoload -U select-word-style
select-word-style shell
zle -N select-word-style
bindkey "^Xw" select-word-style

autoload -U copy-earlier-word
zle -N copy-earlier-word
bindkey '^[;' copy-earlier-word

# endregion

# region ALIASES

alias grep='grep --color=auto'

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

alias clip='tee >(pbcopy)'
alias notify='terminal-notifier -sound default -message Done'
alias now='date "+%Y%m%d-%H%M%S"'
alias today='date "+%Y%m%d"'

# endregion

# region ADDONS

# Using PATH_SET to avoid duplicate entries
if [[ ! -v PATH_SET ]]; then
    PATH="$HOME/.local/bin:$PATH"
    PATH="$(python3 -m site --user-base)/bin:$PATH"

    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(nodenv init -)"
    eval "$(rbenv init -)"

    export PATH_SET=1
fi

eval "$(direnv hook zsh)"

# Needs to be last
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# endregion
