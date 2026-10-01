export PATH="/opt/homebrew/bin:$PATH"
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
export SSL_CERT_FILE="$HOME/.config/certs/ca-bundle-with-zscaler.pem"
export NODE_EXTRA_CA_CERTS="$SSL_CERT_FILE"
export REQUESTS_CA_BUNDLE="$SSL_CERT_FILE"

export UV_SYSTEM_CERTS=1
