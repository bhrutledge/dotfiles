if hashable fd; then
    # https://github.com/sharkdp/fd/blob/master/README.md#using-fd-with-fzf
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
elif hashable rg; then
    export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'
elif hashable ag; then
    export FZF_DEFAULT_COMMAND='ag -g ""'
fi

# source /usr/local/opt/fzf/shell/completion.bash
# source /usr/local/opt/fzf/shell/key-bindings.bash

# https://github.com/junegunn/fzf/wiki/Examples

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
# TODO: Add option for `open`
fe() {
    local files
    IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fuzzy grep open via ripgrep
# TODO: Interactive prompt
fge() {
    local file
    file="$(rg --no-heading $@ | fzf --tac -0 -1)"
    [[ -n $file ]] && ${EDITOR:-vim} $file
}

# checkout git branch
fco() {
    local branches branch
    branches=$(git branch -vv) &&
        branch=$(echo "$branches" | fzf --query="$1" +m) &&
        git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# cd to selected directory
fcd() {
    local dir
    # TODO: Use `fd`, esp. for ignoring
    dir=$(find ${1:-.} -path '*/\.*' -prune \
        -o -type d -print 2> /dev/null | fzf +m) &&
        cd "$dir"

    # TODO: Add option for parent dirs
}

# Fuzzy `z` from fasd
fz() {
    local dir
    dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}
