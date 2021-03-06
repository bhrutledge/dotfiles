# shellcheck shell=bash
if hashable fd; then
    # https://github.com/sharkdp/fd/blob/master/README.md#using-fd-with-fzf
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow'
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
# TODO: Handle multiple files
__fzf_expect_file="--expect=enter,ctrl-e,ctrl-o"
__fzf_process_file() {
    local lines key file
    IFS=$'\n' lines=($1)
    key=${lines[0]}
    file=${lines[1]}

    if ! [[ $file ]]; then
        return 1
    fi

    if [[ $key == "ctrl-e" ]]; then
        eval "${EDITOR:-vim}" "$file"
    elif [[ $key == "ctrl-o" ]]; then
        open "$file"
    else
        echo -n $file | pbcopy
    fi

    echo $file
}

# Preview files with option to edit or open
fp() {
    local preview out

    if hashable bat; then
        preview="bat --color=always"
    else
        preview=cat
    fi

    out=$(fzf $__fzf_expect_file --reverse --query="$1" --preview "$preview {}") \
        && __fzf_process_file "$out"
}

# Preview ripgrep results before opening with the default editor
frg() {
    if ! [[ "$#" -gt 0 ]]; then
        echo "${FUNCNAME[0]}: error: missing PATTERN argument"
        return 1
    fi

    local preview out
    preview="rg --color always --no-line-number --context 2 --context-separator '\n=====\n'"

    out=$(\
        rg --hidden --files-with-matches --no-messages --sort path "$@" \
        | fzf $__fzf_expect_file --preview "$preview '$@' {}" \
        ) \
        && __fzf_process_file "$out"
}

# cd to selected directory
fcd() {
    local dir
    dir=$(fd --type d . "$@" | fzf --preview "ls -F {}") &&
        cd "$dir"
}

# Show git objects (commit, branch, tag, etc) and copy selection
# Assumes the object is the first column
fgo() {
    git "${@:-hist}" --color |
        fzf --ansi --multi --preview='git show --color {1}' |
        cut -d ' ' -f 1 |
        clip
}

# Switch git branch
fgs() {
    local branch
    branch=$(fgo branches) && git switch "${branch#*/}"
}

