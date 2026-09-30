export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

[[ -f "$ZDOTDIR/.zshenv.secret" ]] && source "$ZDOTDIR/.zshenv.secret"

export EDITOR="nvim"
export VISUAL="nvim"
export PATH=$PATH:$HOME/Library/Application\ Support/JetBrains/Toolbox/scripts/
export DOCKER_HOST=unix://$HOME/.rd/docker.sock
export PATH=$HOME/.local/bin:${PATH}
