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
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export SSL_CERT_FILE="$HOME/.config/certs/ca-bundle-with-zscaler.pem"
export NODE_EXTRA_CA_CERTS="$SSL_CERT_FILE"
export REQUESTS_CA_BUNDLE="$SSL_CERT_FILE"

export UV_SYSTEM_CERTS=1

# Desativa o remote repository prefixes filter do Maven Resolver 2.x (Maven 3.9+/3.10),
# que bloqueava artefatos validos (ex.: khttp, com.hotmart.payment:hotcommission) do
# repositorio artifactory-snapshots por nao constarem nas listas de prefixos cacheadas.
export MAVEN_OPTS="${MAVEN_OPTS:+$MAVEN_OPTS }-Daether.remoteRepositoryFilter.prefixes=false"
