# Skip for non-interactive shells
if [[ $- != *i* ]]; then
    return
fi

# Only load this once (e.g., to avoid duplicate PATH)
if [[ $BASHRC ]]; then
    return
else
    export BASHRC=1
fi

# MISC SETTINGS

shopt -s direxpand

export PATH="$HOME/bin:$HOME/.local/bin::$PATH"
export CDPATH=".:$HOME:$HOME/Code"

export PAGER='less'
export EDITOR='code'
export VISUAL=$EDITOR

# MODULAR CONFIGURATION
# Order matters

source ~/.bash/aliases.sh
source ~/.bash/colors.sh
source ~/.bash/prompt.sh
source ~/.bash/history.sh

## SERVICES

if hashable rg; then
    echo -n rg\ 
    export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'
elif hashable ag; then
    echo -n ag\ 
    export FZF_DEFAULT_COMMAND='ag -g ""'
fi

if hashable fd; then
    echo -n fd\ 
    # https://github.com/sharkdp/fd/blob/master/README.md#using-fd-with-fzf
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
fi

if hashable pyenv; then
    echo -n pyenv\ 
    eval "$(pyenv init -)"
    if hashable pyenv-virtualenv-init; then
        eval "$(pyenv virtualenv-init -)"
    fi
fi

if hashable rbenv; then
    echo -n rbenv\ 
    eval "$(rbenv init -)"
fi

# Assuming `brew install bash-completion@2`
# TODO: Locate on Ubuntu, CentOS
if [ -r "/usr/local/etc/profile.d/bash_completion.sh" ]; then
    echo -n bash_completion\ 
    BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
    source "/usr/local/etc/profile.d/bash_completion.sh"
fi

if hashable fasd; then
    echo -n fasd\ 
    eval "$(fasd --init auto)"
fi

if hashable direnv; then
    echo -n direnv\ 
    eval "$(direnv hook bash)"
fi

if hashable fzf; then
    echo -n fzf\ 
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
fi

# LOCAL CONFIGURATION

if [[ -f ~/.bash_exports ]]; then
    source ~/.bash_exports
fi

if [[ -f ~/.bash_aliases ]]; then 
    source ~/.bash_aliases
fi
