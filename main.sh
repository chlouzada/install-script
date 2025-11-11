#!/usr/bin/env bash
set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

if ! echo "$PATH" | grep -q "$LOCAL_BIN"; then
    export PATH="$LOCAL_BIN:$PATH"

    SHELL_NAME=$(basename "$SHELL")
    if [[ "$SHELL_NAME" == "bash" ]]; then
        PROFILE="$HOME/.bashrc"
    elif [[ "$SHELL_NAME" == "zsh" ]]; then
        PROFILE="$HOME/.zshrc"
    else
        PROFILE="$HOME/.profile"
    fi

    if [ -f "$PROFILE" ] && ! grep -q "$LOCAL_BIN" "$PROFILE"; then
        echo "export PATH=\"$LOCAL_BIN:\$PATH\"" >> "$PROFILE"
    fi
fi

sudo apt update -qq &> /dev/null
apt_packages=(
    git
    bash
    curl
    wget
    fzf
    flameshot
    i3
    stow
    openssh-client
    fd-find
    ripgrep
    zip
    unzip
    jq
    bat
)
sudo apt install -y "${apt_packages[@]}" &> /dev/null

# Source dos módulos
source "$SCRIPT_DIR/modules/fish.sh"
source "$SCRIPT_DIR/modules/mise.sh"

source "$SCRIPT_DIR/modules/packages.sh"
source "$SCRIPT_DIR/modules/git.sh"
source "$SCRIPT_DIR/modules/dotfiles.sh"

# Executar instalação de pacotes
# install_packages

# Configurar fish
setup_fish

# Configurar mise
setup_mise

# Configurar git
#setup_git

# Aplicar dotfiles
#apply_dotfiles

# Instalar Claude Code
if ! command -v claude &> /dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash &> /dev/null
fi

BASH_RC="$HOME/.bashrc"
FISH_RC="$HOME/.config/fish/config.fish"
[ -f "$BASH_RC" ] && . "$BASH_RC"
if command -v fish >/dev/null 2>&1; then
    fish -c "source $FISH_RC" >/dev/null 2>&1 || true
fi

echo "FEITO"