#!/usr/bin/env bash

echo "Updating Vim plugins"

if [[ ! -d ~/.vim/bundle/vundle ]]; then
    mkdir -p ~/.vim/bundle
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle
else
    cd ~/.vim/bundle/vundle
    git pull
fi

vim +PluginInstall! +qall
