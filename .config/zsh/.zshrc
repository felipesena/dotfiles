# Load completions
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# History
HISTSIZE=5000
[[ -d "$XDG_STATE_HOME/zsh" ]] || mkdir -p "$XDG_STATE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt numeric_glob_sort

# Include hidden (dot) files/dirs in completion (also affects fzf-tab)
_comp_options+=(globdots)

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# =====================
# Modular Config Files
# =====================

# Aliases
source "$ZDOTDIR/aliases.zsh"

source "$ZDOTDIR/work_aliases.zsh"

# Custom bindings
source "$ZDOTDIR/bindings.zsh"

# Plugins and plugin manager
source "$ZDOTDIR/plugins.zsh"

# Prompt/theme
source "$ZDOTDIR/prompt.zsh"

# Universal yazi-like preview for every completion (dirs -> listing, files -> content)
zstyle ':fzf-tab:complete:*' fzf-preview '$ZDOTDIR/fzf-preview.sh ${(Q)realpath}'

# fzf: use fd so hidden files are listed (but skip .git); shared preview
if command -v fdfind >/dev/null 2>&1; then
	_fd_cmd=fdfind
elif command -v fd >/dev/null 2>&1; then
	_fd_cmd=fd
fi
if [ -n "$_fd_cmd" ]; then
	export FZF_DEFAULT_COMMAND="$_fd_cmd --hidden --follow --exclude .git"
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
	export FZF_ALT_C_COMMAND="$_fd_cmd --type d --hidden --follow --exclude .git"
fi
unset _fd_cmd
export FZF_DEFAULT_OPTS="--preview '$ZDOTDIR/fzf-preview.sh {}' --preview-window=right:60%:wrap"
export FZF_CTRL_T_OPTS="--preview '$ZDOTDIR/fzf-preview.sh {}'"
export FZF_ALT_C_OPTS="--preview '$ZDOTDIR/fzf-preview.sh {}'"

# zoxide interactive query (cd foo<Tab>) preview
export _ZO_FZF_OPTS="--preview '$ZDOTDIR/fzf-preview.sh {2..}' --preview-window=right:60% --height=40% --reverse"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
