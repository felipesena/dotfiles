# dotfiles

Personal dotfiles for macOS and Linux/WSL2, deployed with GNU Stow. The repo
mirrors `$HOME`: files at the repo root and under `.config/` are symlinked into
place by running `stow .` from the repo root.

## Installation

Clone into `~/dotfiles`:

```shell
git clone git@github.com:felipesena/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Install the CLI tooling (neovim, ripgrep, fzf, stow, nvm, sdkman, go, uv, ...).
The script detects the OS: on macOS it installs Homebrew and uses `brew`; on
Linux it uses the system package manager plus official installers. Safe to
re-run.

```shell
./install.sh
```

Create the symlinks:

```shell
stow .          # create/refresh symlinks into $HOME
stow -D .       # remove them
```

## Secrets

Secrets live in `.config/zsh/.zshenv.secret`, which is intentionally
**not** versioned (it's in `.gitignore`). Create it by hand after cloning and
fill in your own values:

```shell
cat > ~/.config/zsh/.zshenv.secret <<'EOF'
export GITHUB_PERSONAL_ACCESS_TOKEN="..."
export JIRA_URL="..."
export JIRA_USERNAME="..."
export JIRA_API_TOKEN="..."
export NEW_RELIC_API_KEY="..."
export GH_TOKEN="..."
EOF
```

Then restart the shell (`exec zsh`) to pick up the new config.

## Notes

- SDKMAN and nvm only install the version managers; use them to install the
  Java/Node runtimes you need.
- Some binaries land in `~/.local/bin` and Go in `/usr/local/go/bin` — make sure
  those are on your `PATH`.
- After `:Lazy update` in Neovim, commit the updated `lazy-lock.json`.
