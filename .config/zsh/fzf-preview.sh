#!/usr/bin/env sh
# Universal preview for fzf-tab (and other fzf integrations).
# Mimics yazi: directories -> listing, files -> content, images -> chafa.

target=$1
[ -z "$target" ] && exit 0

# Resolve ~ and relative paths
case $target in
	"~") target=$HOME ;;
	"~/"*) target=$HOME/${target#"~/"} ;;
esac

BAT=cat
if command -v bat >/dev/null 2>&1; then
	BAT="bat --color=always --style=numbers"
elif command -v batcat >/dev/null 2>&1; then
	BAT="batcat --color=always --style=numbers"
fi

if [ -d "$target" ]; then
	eza --color=always --icons=always --git -a --group-directories-first "$target" 2>/dev/null \
		|| ls -A "$target"
	exit 0
fi

if [ ! -e "$target" ] && [ ! -L "$target" ]; then
	# Not a path (e.g. a completion candidate that isn't a file) -> nothing useful
	printf '%s\n' "$target"
	exit 0
fi

mime=$(file -bL --mime-type "$target" 2>/dev/null)
category=${mime%%/*}
kind=${mime##*/}

case $category in
	image)
		chafa --size "${FZF_PREVIEW_COLUMNS:-80}x${FZF_PREVIEW_LINES:-25}" "$target" 2>/dev/null \
			|| $BAT "$target"
		;;
	text)
		$BAT "$target"
		;;
	*)
		case $kind in
			json|xml|javascript|x-shellscript)
				$BAT "$target" ;;
			pdf)
				pdftotext "$target" - 2>/dev/null | head -n 200 || file -bL "$target" ;;
			*)
				# Fallback: try bat, else describe the binary
				$BAT "$target" 2>/dev/null || file -bL "$target" ;;
		esac
		;;
esac
