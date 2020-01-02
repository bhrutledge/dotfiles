if hashable fd; then
    # https://github.com/sharkdp/fd/blob/master/README.md#using-fd-with-fzf
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
elif hashable rg; then
    export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'
elif hashable ag; then
    export FZF_DEFAULT_COMMAND='ag -g ""'
fi

export FZF_DEFAULT_OPTS="--reverse --exit-0"

# source /usr/local/opt/fzf/shell/completion.bash
# source /usr/local/opt/fzf/shell/key-bindings.bash

# https://github.com/junegunn/fzf/wiki/Examples

# Process two-line output of keypress and file
# enter: Copy selected file to clipboard and echo
# ctrl-e: Open file with $EDITOR
# ctrl-o: Open file with `open`
# TODO: Maybe move all array handling there
# TODO: Handle multiple files
__expect_file_arg="--expect=enter,ctrl-e,ctrl-o"
__process_expect_file() {
    local key file
    key=$1
    file=$2

    if ! [[ $file ]]; then
        return 1
    fi

    if [[ $key == "ctrl-e" ]]; then
        ${EDITOR:-vim} "$file"
    elif [[ $key == "ctrl-o" ]]; then
        open "$file"
    else
        echo -n $file | pbcopy
    fi

    echo $file
}

# Preview files with option to edit or open
# TODO: Use `bat` for preview if it's hashable
fp() {
    local preview out
    preview=cat

    IFS=$'\n' out=($(\
        fzf $__expect_file_arg --reverse --query="$1" --preview "$preview {}" \
    ))
    __process_expect_file "${out[@]}"
}

# Preview ripgrep results before opening with the default editor
# TODO: Use fzf prompt for query instead of file?
frg() {
    if ! [[ "$#" -gt 0 ]]; then echo "${FUNCNAME[0]}: error: missing PATTERN argument"; return 1; fi

    local preview out
    preview="rg --color always --no-line-number --context 2 --context-separator '\n=====\n'"

    IFS=$'\n' out=($(\
        rg --hidden --files-with-matches --no-messages --sort path "$@" \
        | fzf $__expect_file_arg --preview "$preview '$@' {}" \
    ))
    __process_expect_file "${out[@]}"
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
