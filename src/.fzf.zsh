# Fuzzy Find
# https://github.com/junegunn/fzf/

export FZF_DEFAULT_OPTS="--ansi --reverse --exit-0 --bind=ctrl-z:ignore,ctrl-r:toggle-sort"

# https://github.com/sharkdp/fd/blob/master/README.md#using-fd-with-fzf
# TODO: Extract common fd options
export FZF_DEFAULT_COMMAND="fd --color always --hidden --follow"

# Based on `$(brew --prefix)/opt/fzf/shell/key-bindings.zsh`
# https://github.com/junegunn/fzf/#key-bindings-for-command-line
# https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
# TODO: Add setopt, ret, and reset-prompt if necessary

join-quoted-lines() {
  local line
  while read line; do
    echo -n "${(q)line} "
  done
}

# TODO: Add `ls -l` to preview
# TODO: `$EDITOR` or `open` if BUFFER is empty
fzf-file() {
    LBUFFER+=$(
        fd --color always --hidden --follow --type f |
            fzf --multi --tiebreak=end --preview='bat --color always {}' |
            join-quoted-lines
    )
}
zle -N fzf-file
bindkey '^@f' fzf-file

fzf-directory() {
    local selection
    selection=$(
        fd --hidden --follow --type d |
            fzf --tiebreak=end --preview='fd --color always --hidden --base-directory {} --list-details --max-depth 1'
    )
    [[ -n "$selection" ]] || return;

    if [[ -z "$BUFFER" ]]; then
        BUFFER="cd ${(q)selection}"
        zle accept-line
    else
        LBUFFER+=${(q)selection}
    fi
}
zle -N fzf-directory
bindkey '^@d' fzf-directory

# TODO: Extract "execute or append" logic shared w/ fzf-directory
fzf-recent-directory() {
    local selection
    selection=$(
        cdr -l | tr -s ' ' | cut -d ' ' -f 2- |
            fzf --tiebreak=end
    )
    [[ -n "$selection" ]] || return;

    # Don't need (q) because `cdr -l` is already quoted
    if [[ -z "$BUFFER" ]]; then
        BUFFER="cd $selection"
        zle accept-line
    else
        LBUFFER+=$selection;
    fi
}
zle -N fzf-recent-directory
bindkey '^@-' fzf-recent-directory

# TODO: execute; https://github.com/junegunn/fzf/issues/477
fzf-history() {
    BUFFER=$(
        fc -lnr 1 |
            perl -ne 'print unless $seen{$_}++' |
            fzf --height=40% --tiebreak=index --query=$LBUFFER
    )
    zle end-of-line
    zle redisplay
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
# TODO: Add default commands ala `fzf-directory`

fzf-git-select() {
    fzf --multi --preview="git ${@:-show} --color {1}" |
        cut -d ' ' -f 1 |
        join-quoted-lines
}

fzf-git-branch() {
    local selection
    selection=$(git branches --color | fzf-git-select hist)
    [[ -n "$selection" ]] || return;

    if [[ -z "$BUFFER" ]]; then
        # TODO: Use rev-parse to allow branches with slashes
        # selection=$(git rev-parse --symbolic-full-name $selection)
        # selection=${selection##refs/remotes/*/}
        # selection=${selection##refs/heads/}
        selection=${selection##*/}
        BUFFER="git switch $selection"
        zle end-of-line
        # zle accept-line
    else
        LBUFFER+=$selection;
    fi
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

# TODO: Preview untracked files
# Maybe use ls-files ala `git aliases`
fzf-git-diff() {
    LBUFFER+=$(
        git -c color.status=always stat |
            fzf --multi --preview 'git diff --color HEAD -- {-1}' |
            cut -c 4- |
            join-quoted-lines
    )
}
zle -N fzf-git-diff
bindkey "^Gd" fzf-git-diff
