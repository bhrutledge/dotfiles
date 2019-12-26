shopt -s direxpand

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export CDPATH=".:$HOME:$HOME/Code"

for dir in ~/Dropbox*; do
    if [[ -L $dir ]]; then
        continue
    fi

    PATH="$dir/bin:$PATH"
    CDPATH="$CDPATH:$dir/Code"
done

unset dir
