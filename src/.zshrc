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

export EDITOR="vim"
if [[ $TERM_PROGRAM == "vscode" ]]; then
    EDITOR="code --wait"
fi
export VISUAL=$EDITOR

export BAT_THEME="Visual Studio Dark+"

# endregion

# region PROMPT

# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
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
PROMPT+='${VIRTUAL_ENV+ (${VIRTUAL_ENV:t2})}'
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
# https://zsh.sourceforge.io/Guide/zshguide06.html
# https://github.com/zsh-users/zsh-completions

FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

zstyle ':completion:*' use-cache on

# zstyle ':completion:*' format '%F{8}completing %d%f'
# zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt ''

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
unsetopt LIST_TYPES

autoload -Uz compinit
compinit

zmodload zsh/complist
# Shift-Tab to select first match and cycle
bindkey '^[[Z' menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete
# Interactive mode; ^S for search
bindkey -M menuselect '^Xi' vi-insert
# Select match and try completion again
bindkey -M menuselect '^O' accept-and-infer-next-history
# Enter to select match and execute; ^J to just select
bindkey -M menuselect '^M' .accept-line

# https://zsh.sourceforge.io/Doc/Release/Options.html#Changing-Directories
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Recent-Directories
# TODO: Remove in favor of zoxide
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
add-zsh-hook -Uz zsh_directory_name zsh_directory_name_cdr
zstyle ':chpwd:*' recent-dirs-max 100
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert fallback

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

bindkey '^[k' describe-key-briefly

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
autoload -U select-word-style
select-word-style shell
zle -N select-word-style
bindkey "^Xw" select-word-style

zstyle ':zle:*-word-bash' word-style standard
zstyle ':zle:*-word-bash' word-chars ''

zle -N forward-word-bash forward-word-match
bindkey '^Xf' forward-word-bash

zle -N backward-word-bash backward-word-match
bindkey '^Xb' backward-word-bash

# Overriding _list_expansions, which doesn't seem to do anything
zle -N kill-word-bash kill-word-match
bindkey '^Xd' kill-word-bash

zle -N backward-kill-word-bash backward-kill-word-match
bindkey '^X^?' backward-kill-word-bash

autoload -U copy-earlier-word
zle -N copy-earlier-word
bindkey '^[;' copy-earlier-word

bindkey "^Xr" history-beginning-search-backward
bindkey "^Xs" history-beginning-search-forward

bindkey "^W" kill-region

# Overriding push-line
bindkey "^[q" push-line-or-edit
bindkey "^[Q" push-input

# TODO: pbcopy-kill-region
pbcopy-region-as-kill () {
    zle copy-region-as-kill
    print -rn $CUTBUFFER | pbcopy
}
zle -N pbcopy-region-as-kill
bindkey "^[w" pbcopy-region-as-kill

# endregion

# region ALIASES

alias grep='grep --color=auto'

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Insert time/date stamps
#     ls -l > files-$(now).txt
alias now='date "+%Y%m%d-%H%M%S"'
alias today='date "+%Y%m%d"'

# Copy input to clipboard
#     ls -l | clip
alias clip='tee >(pbcopy)'

alias tree='tree -I "$(paste -d\| -s $HOME/.treeignore)"'

# Alert after long-running commands
#     pytest; status
# terminal-notifier needs old macOS sound names:
# https://github.com/julienXX/terminal-notifier/issues/283#issuecomment-832569237

notify() {
    terminal-notifier -message "$1"  -sound "${2-Default}"
}

status() {
    local code=$?
    local message="Success"
    local sound="Glass"

    if [[ $code -ne 0 ]]; then
        message="Failed: $?"
        sound="Ping"
    fi

    notify "$message" "$sound"
}

# endregion

# region FUZZY FIND
# https://github.com/junegunn/fzf/
# TODO: Extract to .fzf.zsh

export FZF_DEFAULT_OPTS="--ansi --reverse --exit-0 --bind=ctrl-z:ignore"

# https://github.com/sharkdp/fd/blob/master/README.md#using-fd-with-fzf
# TODO: Extract common fd options
export FZF_DEFAULT_COMMAND="fd --color always --hidden --follow"

# Based on `$(brew --prefix)/opt/fzf/shell/key-bindings.zsh`
# https://github.com/junegunn/fzf/#key-bindings-for-command-line
# https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
# TODO: Add setopt, ret, and reset-prompt if necessary

join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

# TODO: Add `ls -l` to preview
# TODO: `$EDITOR` if buffer is empty
fzf-file() {
    LBUFFER+=$(
        fd --color always --hidden --follow --type f |
            fzf --multi --preview 'bat --color always {}' |
            join-lines
    )
}
zle -N fzf-file
bindkey '^@f' fzf-file

# TODO: `cd` if buffer is empty
fzf-directory() {
    LBUFFER+=$(
        fd --hidden --follow --type d |
            fzf --multi --preview 'fd --color always --hidden --base-directory {} --list-details --max-depth 1' |
            join-lines
    )
}
zle -N fzf-directory
bindkey '^@d' fzf-directory

# TODO: Simplify via `fc -lnr 1` and `BUFFER=`
# TODO: execute; https://github.com/junegunn/fzf/issues/477
# TODO: timestamp
fzf-history() {
    local selected num
    selected=($(
        fc -rl 1 |
            perl -ne 'print unless $seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' |
            fzf --height 40% -n2.. --query=$LBUFFER
    ))
    num=$selected[1]
    if [[ -n $num ]]; then
        zle vi-fetch-history -n $num
    fi
    # TODO: Why is this necessary?
    zle reset-prompt
}
zle -N fzf-history
bindkey '^@r' fzf-history

fzf-execute-widget() {
    local widget
    widget="$(zle -l | grep -v '^orig' | cut -d ' ' -f 1 | fzf --height 40%)"
    # TODO: Compare this to `reset-prompt` and `-R`
    zle redisplay
    if [[ -n $widget ]]; then
        # This doesn't work for execute(-last)-named-cmd
        zle "$widget"
    fi
}
zle -N fzf-execute-widget
bindkey '^@x' fzf-execute-widget

# Show git objects (commit, branch, tag, etc) and copy selection
# Assumes the object is the first column
# Inspired by https://junegunn.kr/2016/07/fzf-git
# and https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236

fzf-git-select() {
    fzf --multi --preview="git ${@:-show} --color {1}" |
        cut -d ' ' -f 1 |
        join-lines
}

fzf-git-branch() {
    LBUFFER+=$(git branches --color | fzf-git-select hist)
}
zle -N fzf-git-branch
bindkey "^Gb" fzf-git-branch

fzf-git-hash() {
    LBUFFER+=$(git hist --color | fzf-git-select)
}
zle -N fzf-git-hash
bindkey "^Gh" fzf-git-hash

fzf-git-reflog() {
    LBUFFER+=$(git reflog --color --no-decorate --format='%C(yellow)%gd %C(auto)%gs' | fzf-git-select)
}
zle -N fzf-git-reflog
bindkey "^Gr" fzf-git-reflog

fzf-git-stash() {
    LBUFFER+=$(git stash --color list --no-decorate --format='%C(yellow)%gd %C(auto)%gs' | fzf-git-select)
}
zle -N fzf-git-stash
bindkey "^Gs" fzf-git-stash

fzf-git-tag() {
    LBUFFER+=$(git tag --color | fzf-git-select)
}
zle -N fzf-git-tag
bindkey "^Gt" fzf-git-tag

# TODO: Support more statuses
# `cat` untracked files
# Maybe use ls-files ala `git aliases`
fzf-git-status() {
    LBUFFER+=$(
        git -c color.status=always stat |
            fzf --multi --preview 'git diff --color HEAD -- {-1}' |
            cut -c 4- |
            join-lines
    )
}
zle -N fzf-git-status
bindkey "^Gg" fzf-git-status

# endregion

# region ADDONS

# Using PATH_SET to avoid duplicate entries in sub-shells
if [[ ! -v PATH_SET ]]; then
    PATH="$HOME/.local/bin:$PATH"
    PATH="$(python3 -m site --user-base)/bin:$PATH"

    if (( $+commands[pyenv] )); then
        eval "$(pyenv init --path)"
        eval "$(pyenv init -)"
    fi

    (( $+commands[nodenv] )) && eval "$(nodenv init -)"
    (( $+commands[rbenv] )) && eval "$(rbenv init -)"

    export PATH_SET=1
fi

(( $+commands[direnv] )) && eval "$(direnv hook zsh)"

# TODO: Replace with fzf widget(s) based on `cdr -l`
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
    alias zq="zoxide query"
    alias zqi="zoxide query -i"
fi

# Needs to be last
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# endregion
