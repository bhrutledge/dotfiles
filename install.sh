#!/bin/sh

echo "Updating dotfiles"

if [[ ! -d ~/.dotfiles ]]; then
    git clone https://github.com/bhrutledge/dotfiles.git ~/.dotfiles
else
    cd ~/.dotfiles
    git pull
fi

echo "Updating prezto"

if [[ ! -d ~/.zprezto ]]; then
    git clone https://github.com/bhrutledge/prezto.git ~/.zprezto
else
    cd ~/.zprezto
    git pull
fi

for dir in ~/.dotfiles ~/.zprezto/runcoms; do
    for file in `ls -1 $dir | grep -v -e LICENSE -e README -e install`; do
        src_file=$dir/$file
        dest_file=~/.$file

        if [[ -a $dest_file && ! -h $dest_file ]]; then
            echo "Backing up $dest_file"
            mv $dest_file ${dest_file}.orig
        fi

        echo "Linking $dest_file"
        ln -sf $src_file $dest_file
    done
done

echo "Updating vim plugins"

if [[ ! -d ~/.vim/bundle/vundle ]]; then
    mkdir -p ~/.vim/bundle
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle
else
    cd ~/.vim/bundle/vundle
    git pull
fi

vim +PluginInstall! +qall

