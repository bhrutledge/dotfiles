#!/usr/bin/env bash

# Inspiration:
# https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile

for file in $HOME/.bash/{exports,aliases,prompt}.bash; do
	source "$file";
done;
unset file;

# TODO: Make this a loop over a list of files
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /usr/local/bin/virtualenvwrapper.sh ] && . /usr/local/bin/virtualenvwrapper.sh
