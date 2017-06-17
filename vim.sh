#!/usr/bin/env bash

echo "Updating Vim plugins"

if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
    mkdir -p ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
else
    cd ~/.vim/bundle/vundle
    git pull
fi

vim +PluginInstall! +qall
