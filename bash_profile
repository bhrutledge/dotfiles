# Inspiration:
# https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile

export PATH=$HOME/bin:$HOME/.local/bin:$PATH

for file in ~/.{bash_prompt,exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# TODO: Add this to the generic sourcing list above
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
