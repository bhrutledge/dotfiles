# Borrowed from YS theme

# Machine name.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

# Directory info.
local current_dir='${PWD/#$HOME/~}'

# Git info.
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[magenta]%}]"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}x"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Virtuaenv info.
local venv_info='$(virtualenv_prompt_info)'


PROMPT="
%{$fg[green]%}%n@$(box_name):%{$reset_color%}${current_dir} \
${git_info}${venv_info}
%{$fg[green]%}$ %{$reset_color%}"
