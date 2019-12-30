if hashable fd; then
    # https://github.com/sharkdp/fd/blob/master/README.md#using-fd-with-fzf
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
elif hashable rg; then
    export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'
elif hashable ag; then
    export FZF_DEFAULT_COMMAND='ag -g ""'
fi

export FZF_DEFAULT_OPTS="--reverse --select-1 --exit-0"

# source /usr/local/opt/fzf/shell/completion.bash
# source /usr/local/opt/fzf/shell/key-bindings.bash

# https://github.com/junegunn/fzf/wiki/Examples

# Open the selected file with the default editor
# TODO: Add option for `open`
# TODO: Add option for echo and/or copy
# TODO: Use `bat` if it's hashable
fe() {
    local preview files
    preview=cat
    IFS=$'\n' files=($(fzf --reverse --query="$1" --multi --preview "$preview {}")) \
        && ${EDITOR:-vim} "${files[@]}"
}

# Preview ripgrep results before opening with the default editor
# TODO: See fe()
frg() {
    local preview file
    preview="rg --color always --no-line-number --context 2 --context-separator '\n=====\n'"
    file=$(rg --hidden --files-with-matches --no-messages --sort path "$@" | fzf --preview "$preview '$@' {}") \
        && ${EDITOR:-vim} "$file"
}

# cd to selected directory
fcd() {
    local dir
    dir=$(fd --type d --hidden --follow "$@" | fzf --preview "ls -F {}") \
        && cd "$dir"
}

# cd to recent directory ala `z` from fasd
fz() {
    local dir
    dir=$(fasd -Rdl "$@" | fzf --no-sort) \
        && cd "$dir"
}

# Checkout git branch
fco() {
    local branch
    branch=$(git branch --list -vv | grep -v '*' | fzf --query="$1") \
        && git checkout $(echo $branch | awk '{print $1}')
}
