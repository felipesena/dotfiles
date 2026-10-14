# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Ctrl+W: delete only up to the previous word boundary (stops at / : @ . - etc.)
# instead of swallowing the whole path. Treats punctuation as word separators by
# emptying WORDCHARS locally during the kill.
backward-kill-dir() {
  local WORDCHARS=''
  zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^w' backward-kill-dir


bindkey ';5C' forward-word
bindkey ';5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
