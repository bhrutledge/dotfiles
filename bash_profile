# Inspiration:
# https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile

for file in $HOME/.shell/*; do
	[ -f "$file" ] && source "$file";
done;
unset file;

# TODO: Add this to the generic sourcing list above
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /usr/local/bin/virtualenvwrapper.sh ] && . /usr/local/bin/virtualenvwrapper.sh
