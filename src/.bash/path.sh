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

export PATH_SET=1
