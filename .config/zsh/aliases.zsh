# Better ls
alias ls='eza --color always --icons always --git -l --no-time --no-user --no-permissions -a'

# Tree view
alias tree='eza --tree --icons -a'

# Better cat
if command -v bat >/dev/null 2>&1; then
	alias cat='bat'
elif command -v batcat >/dev/null 2>&1; then
	alias bat='batcat'
	alias cat='bat'
fi

# fd (fdfind on Ubuntu)
if command -v fdfind >/dev/null 2>&1; then
	alias fd='fdfind'
fi

alias python='python3'
