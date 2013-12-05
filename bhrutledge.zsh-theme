# Started from YS theme

# Machine name.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

# Directory info.
local current_dir='${PWD/#$HOME/~}'

local ob="%{$fg[yellow]%}[%{$reset_color%}";
local cb="%{$fg[yellow]%}]%{$reset_color%}";

# Git info.
ZSH_THEME_GIT_PROMPT_PREFIX=$ob
ZSH_THEME_GIT_PROMPT_SUFFIX=$cb
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}x"
ZSH_THEME_GIT_PROMPT_CLEAN=""
local git_info='$(git_prompt_info)'

# Virtuaenv info.

function virtualenv_prompt_info(){
  if [[ -n $VIRTUAL_ENV ]]; then
    printf "%s%s%s" $ob ${${VIRTUAL_ENV}:t} $cb
  fi
}

local venv_info='$(virtualenv_prompt_info)'

PROMPT="
${ob}%n@$(box_name)${cb}${ob}${current_dir}${cb} ${git_info}${venv_info}
$ "

