# dotfiles

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for a Linux/WSL2 system, deployed with GNU Stow. The repo mirrors the target `$HOME` layout: files at the repo root (`.zshenv`, `.lessfilter`) and under `.config/` are symlinked into place by running `stow .` from the repo root. Editing a file here changes the live config through the symlink.

## Deployment

```shell
stow .          # create/refresh symlinks from repo root into $HOME
stow -D .       # remove them
```

Requires `git` and `stow`. There is no build or test suite; "testing" a change means starting a new shell (`exec zsh`) or restarting Neovim.

## Shell configuration (zsh)

Uses XDG-style relocation. `.zshenv` (the only file zsh reads from `$HOME`) sets `ZDOTDIR="$XDG_CONFIG_HOME/zsh"`, so the real config lives in `.config/zsh/`:

- `.zshrc` — entry point: completion setup, history (stored in `$XDG_STATE_HOME/zsh/history`), then sources the modular files below in order, then shell integrations (`fzf`, `zoxide` aliased to `cd`). SDKMAN init must stay last.
- `aliases.zsh` — `ls`/`tree`/`cat` remapped to `eza`/`bat`; guards for Ubuntu binary names (`batcat`, `fdfind`).
- `bindings.zsh` — emacs keymap, `^p`/`^n` history search.
- `plugins.zsh` — Zinit plugin manager (self-installs on first run) + zsh-users plugins and `fzf-tab`.
- `prompt.zsh` — oh-my-posh, themed by `.config/ohmyposh/config.toml`.

When adding shell config, put it in the matching modular file and keep `.zshrc`'s source order intact.

`.lessfilter` is the `lesspipe` preview hook (used by `fzf` previews and `less`): dispatches on MIME type to `eza`, `chafa`, `bat`, etc.

## Neovim configuration

`.config/nvim/` is a **LazyVim-based** config on `lazy.nvim`.

- `init.lua` → `lua/config/lazy.lua` bootstraps lazy.nvim and imports every file in `lua/config/plugins/` as a plugin spec. Add a plugin by dropping a new `lua/config/plugins/<name>.lua` that returns a lazy spec table.
- `plugin/` files load automatically at startup (not through lazy): `options.lua`, `keymaps.lua`, `floaterminal.lua` (custom floating terminal, `<leader>oft`).
- `after/ftplugin/lua.lua` — per-filetype overrides (2-space indent for Lua).
- Leader is `<space>`.
- LSP (`lua/config/plugins/lsp.lua`): servers and formatters are installed via Mason. To add a language server, add it to the `servers` table; add formatters to the `formatters` list. Format-on-save is wired through an `LspAttach` autocmd. Current servers: `lua_ls`, `pyright`, `gopls`, `kotlin_language_server`; formatters: `stylua`, `ktlint`.
- Completion is `blink.cmp` (not nvim-cmp); LSP capabilities come from it.
- Fuzzy finding is Telescope with a custom `lua/config/telescope/multigrep.lua` (`<leader>fg`) — split the prompt on a double space to pass a ripgrep glob as the second term.
- Treesitter parsers are an explicit list in `lua/config/plugins/treesitter.lua`.
- File explorer is `oil.nvim` (`-` to open parent dir).
- `lazy-lock.json` is the committed lockfile — commit it after `:Lazy update`.

## Conventions

Commit messages use Conventional Commits, almost always `chore: <lowercase summary>`.
