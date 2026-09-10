#!/usr/bin/env bash
#
# install.sh — bootstrap CLI tooling on a fresh machine (macOS or Linux).
#
# Installs: neovim ffmpeg jq poppler fd ripgrep fzf zoxide resvg imagemagick
#           nvm sdkman golang uv
#
# On macOS: installs Homebrew (if missing) and uses `brew` for everything it can.
# On Linux: uses the system package manager (apt/dnf/pacman/zypper) plus the
#           official installers for tools that aren't reliably packaged.
#
# Safe to re-run: every step checks whether the tool is already present.

set -euo pipefail

GO_VERSION="1.23.4"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m warn:\033[0m %s\n' "$*" >&2; }
have() { command -v "$1" >/dev/null 2>&1; }

OS="$(uname -s)"
ARCH="$(uname -m)"

# ---------------------------------------------------------------------------
# Package-manager abstraction
# ---------------------------------------------------------------------------

PKG=""          # apt | dnf | pacman | zypper | brew
SUDO=""

detect_linux_pkg() {
  if have apt-get; then PKG=apt
  elif have dnf;   then PKG=dnf
  elif have pacman; then PKG=pacman
  elif have zypper; then PKG=zypper
  else
    warn "No supported package manager found; relying on manual installers only."
  fi
  if [ "$(id -u)" -ne 0 ] && have sudo; then SUDO="sudo"; fi
}

pkg_update() {
  case "$PKG" in
    apt)    $SUDO apt-get update -y ;;
    dnf)    $SUDO dnf -y makecache ;;
    pacman) $SUDO pacman -Sy --noconfirm ;;
    zypper) $SUDO zypper --non-interactive refresh ;;
    brew)   brew update ;;
  esac
}

# pkg_install <generic-name> [apt-name] [dnf-name] [pacman-name] [zypper-name] [brew-name]
pkg_install() {
  local generic="$1"; shift
  local apt_n="${1:-$generic}" dnf_n="${2:-$generic}" pac_n="${3:-$generic}" zyp_n="${4:-$generic}" brew_n="${5:-$generic}"
  case "$PKG" in
    apt)    $SUDO apt-get install -y "$apt_n" ;;
    dnf)    $SUDO dnf install -y "$dnf_n" ;;
    pacman) $SUDO pacman -S --needed --noconfirm "$pac_n" ;;
    zypper) $SUDO zypper --non-interactive install -y "$zyp_n" ;;
    brew)   brew install "$brew_n" ;;
    *)      warn "Cannot install $generic: no package manager." ; return 1 ;;
  esac
}

# ---------------------------------------------------------------------------
# macOS: Homebrew
# ---------------------------------------------------------------------------

install_homebrew() {
  if have brew; then
    log "Homebrew already installed."
  else
    log "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  # Make brew available in this shell (Apple Silicon vs Intel paths).
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  PKG=brew
}

# ---------------------------------------------------------------------------
# Individual tools
# ---------------------------------------------------------------------------

install_pkg_tools() {
  # generic          apt              dnf             pacman         zypper            brew
  have nvim   || pkg_install neovim   neovim           neovim          neovim         neovim            neovim
  have ffmpeg || pkg_install ffmpeg   ffmpeg           ffmpeg          ffmpeg          ffmpeg            ffmpeg
  have jq     || pkg_install jq       jq               jq              jq              jq                jq
  have stow   || pkg_install stow     stow             stow            stow            stow              stow
  # poppler provides pdftoppm / pdfinfo (used by yazi & .lessfilter previews)
  have pdftoppm || pkg_install poppler poppler-utils   poppler-utils   poppler         poppler-tools     poppler
  have fzf    || pkg_install fzf      fzf              fzf             fzf             fzf               fzf
  have magick || have convert || pkg_install imagemagick imagemagick   ImageMagick     imagemagick     ImageMagick       imagemagick

  # bat: binary is `batcat` on Debian/Ubuntu (aliases.zsh already guards for that)
  if ! have bat && ! have batcat; then
    pkg_install bat
  fi

  # fd: binary is `fdfind` on Debian/Ubuntu (aliases.zsh already guards for that)
  if ! have fd && ! have fdfind; then
    pkg_install fd fd-find fd-find fd fd fd
  fi

  # ripgrep
  have rg || pkg_install ripgrep

  # zoxide — not in older apt repos; fall back to official installer
  if ! have zoxide; then
    if [ "$PKG" = brew ] || [ "$PKG" = pacman ] || [ "$PKG" = dnf ]; then
      pkg_install zoxide
    elif [ "$PKG" = apt ] && apt-cache show zoxide >/dev/null 2>&1; then
      pkg_install zoxide
    else
      log "Installing zoxide via official script..."
      curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh \
        | bash -s -- --bin-dir "$HOME/.local/bin"
    fi
  fi

  # resvg — packaged on brew/pacman; elsewhere via cargo or GitHub release
  if ! have resvg; then
    if [ "$PKG" = brew ] || [ "$PKG" = pacman ]; then
      pkg_install resvg
    elif have cargo; then
      log "Installing resvg via cargo..."
      cargo install resvg
    else
      install_resvg_release
    fi
  fi
}

install_resvg_release() {
  local ver url tmp
  ver="$(curl -sSfL https://api.github.com/repos/linebender/resvg/releases/latest \
        | jq -r .tag_name)"
  case "$OS-$ARCH" in
    Linux-x86_64)  url="https://github.com/linebender/resvg/releases/download/${ver}/resvg-linux-x86_64.tar.xz" ;;
    Linux-aarch64) url="https://github.com/linebender/resvg/releases/download/${ver}/resvg-linux-aarch64.tar.xz" ;;
    *) warn "No resvg prebuilt binary for $OS-$ARCH; install Rust and run 'cargo install resvg'." ; return 0 ;;
  esac
  tmp="$(mktemp -d)"
  log "Installing resvg ${ver} from GitHub release..."
  curl -sSfL "$url" | tar -xJ -C "$tmp"
  mkdir -p "$HOME/.local/bin"
  install -m 0755 "$tmp/resvg" "$HOME/.local/bin/resvg"
  rm -rf "$tmp"
}

install_go() {
  if have go; then
    log "Go already installed ($(go version))."
    return
  fi
  if [ "$PKG" = brew ]; then
    brew install go
    return
  fi
  local goarch tarball
  case "$ARCH" in
    x86_64)  goarch=amd64 ;;
    aarch64|arm64) goarch=arm64 ;;
    *) warn "Unknown arch $ARCH for Go; skipping." ; return 0 ;;
  esac
  tarball="go${GO_VERSION}.linux-${goarch}.tar.gz"
  log "Installing Go ${GO_VERSION}..."
  curl -sSfL "https://go.dev/dl/${tarball}" -o "/tmp/${tarball}"
  $SUDO rm -rf /usr/local/go
  $SUDO tar -C /usr/local -xzf "/tmp/${tarball}"
  rm -f "/tmp/${tarball}"
  warn 'Add /usr/local/go/bin to PATH (e.g. in .config/zsh/) if it is not already.'
}

install_uv() {
  if have uv; then
    log "uv already installed ($(uv --version))."
    return
  fi
  if [ "$PKG" = brew ]; then
    brew install uv
    return
  fi
  log "Installing uv (Python) via official installer..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
}

install_nvm() {
  if [ -d "${NVM_DIR:-$HOME/.nvm}" ]; then
    log "nvm already installed."
    return
  fi
  log "Installing nvm..."
  local nvm_ver
  nvm_ver="$(curl -sSfL https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r .tag_name)"
  curl -sSfL "https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_ver}/install.sh" | bash
}

install_sdkman() {
  if [ -d "${SDKMAN_DIR:-$HOME/.sdkman}" ]; then
    log "SDKMAN already installed."
    return
  fi
  log "Installing SDKMAN..."
  export SDKMAN_DIR="$HOME/.sdkman"
  curl -sSfL "https://get.sdkman.io?rcupdate=false" | bash
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

main() {
  if ! have curl; then
    echo "curl is required to run this script." >&2
    exit 1
  fi

  case "$OS" in
    Darwin)
      log "Detected macOS ($ARCH)."
      install_homebrew
      ;;
    Linux)
      log "Detected Linux ($ARCH)."
      detect_linux_pkg
      ;;
    *)
      echo "Unsupported OS: $OS" >&2
      exit 1
      ;;
  esac

  [ -n "$PKG" ] && pkg_update || true

  install_pkg_tools
  install_go
  install_uv
  install_nvm
  install_sdkman

  log "Done. Restart your shell (exec zsh) to pick up new PATH entries."
}

main "$@"
