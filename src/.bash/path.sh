if [[ -v PATH_SET ]]; then
    return
fi

shopt -s globstar
shopt -s extglob
shopt -s direxpand

export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/sbin/:$PATH"
export CDPATH=".:$HOME:$HOME/Code"

for dir in ~/Dropbox*; do
    if [[ -L $dir ]]; then
        continue
    fi

    PATH="$dir/bin:$PATH"
    CDPATH="$CDPATH:$dir/Code"
done
unset dir

if hashable pyenv; then
    current_path=$PATH

    eval "$(pyenv init -)"
    if hashable pyenv-virtualenv-init; then
        eval "$(pyenv virtualenv-init -)"
    fi

    if [[ $current_path == *pyenv* ]]; then
        PATH=$current_path
    fi

    unset current_path
fi

if hashable rbenv; then
    current_path=$PATH

    eval "$(rbenv init -)"

    if [[ $current_path == *rbenv* ]]; then
        PATH=$current_path
    fi

    unset current_path
fi

if hashable nodenv; then
    current_path=$PATH

    eval "$(nodenv init -)"

    if [[ $current_path == *nodenv* ]]; then
        PATH=$current_path
    fi

    unset current_path
fi

export PATH_SET=1

export PATH="/Users/brian/.deta/bin:$PATH"
