#!/usr/bin/env bash

# TODO: Add interactive and dry-run options

echo "Updating dotfiles"
git pull

GLOBIGNORE=".:..:*.swp:*~:.git"

for file in .*; do
    src_file=$PWD/$file
    dest_file=~/$file

    if [[ -h $dest_file ]]; then
        # Remove existing links
        rm -f $dest_file
    elif [[ -a $dest_file ]]; then
        echo "Backing up $dest_file"
        mv $dest_file ${dest_file}.orig
    fi

    echo "Linking $dest_file"
    ln -s $src_file $dest_file
done
