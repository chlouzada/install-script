#!/usr/bin/env bash

setup_fish() {
    DISTRO=""
    DISTRO_LIKE=""
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_LIKE=$ID_LIKE
    else
        DISTRO="unknown"
    fi

    if ! command -v fish &>/dev/null; then
        echo "  -> Instalando Fish shell..."
        if [[ "$DISTRO" == "ubuntu" ]] || [[ "$DISTRO_LIKE" == *"ubuntu"* ]]; then
            sudo apt update -qq &> /dev/null
            sudo apt install -y software-properties-common curl gnupg &> /dev/null
            sudo apt-add-repository -y ppa:fish-shell/release-4 &> /dev/null
            sudo apt update -qq &> /dev/null
            sudo apt install -y fish &> /dev/null
        elif [[ "$DISTRO" == "debian" ]] || [[ "$DISTRO_LIKE" == *"debian"* ]]; then
            sudo apt update &> /dev/null
            sudo apt install -y gnupg curl ca-certificates &> /dev/null 

            DEB_VERSION=$(grep -oP '(?<=VERSION_ID=")[0-9]+' /etc/os-release)
            echo "  -> Detectado Debian $DEB_VERSION, adicionando repositório oficial do Fish..."
            echo "deb http://download.opensuse.org/repositories/shells:/fish/Debian_${DEB_VERSION}/ /" | \
                sudo tee /etc/apt/sources.list.d/shells:fish.list
            curl -fsSL "https://download.opensuse.org/repositories/shells:fish/Debian_${DEB_VERSION}/Release.key" | \
                gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish.gpg >/dev/null
            sudo apt update -qq &> /dev/null
            sudo apt install -y fish &> /dev/null
        else
            return 1
        fi
    fi

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    FISH_CONFIG_SRC="$SCRIPT_DIR/configs/fish"
    FISH_CONFIG_DEST="$HOME/.config/fish"

    mkdir -p "$FISH_CONFIG_DEST/functions"

    cp "$FISH_CONFIG_SRC/config.fish" "$FISH_CONFIG_DEST/config.fish"
    cp "$FISH_CONFIG_SRC/aliases.fish" "$FISH_CONFIG_DEST/aliases.fish"
    if [ -d "$FISH_CONFIG_SRC/functions" ]; then
        cp "$FISH_CONFIG_SRC/functions"/*.fish "$FISH_CONFIG_DEST/functions/" 2>/dev/null || true
    fi

    if [ "$SHELL" != "$(command -v fish)" ]; then
        if ! grep -q "$(command -v fish)" /etc/shells; then
            echo "$(command -v fish)" | sudo tee -a /etc/shells >/dev/null
        fi
        chsh -s "$(command -v fish)"
    fi

    BASHRC="$HOME/.bashrc"
    if [ -f "$BASHRC" ] && ! grep -q "exec fish" "$BASHRC"; then
        cat >>"$BASHRC" <<'EOF'

# Auto-start fish shell
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} ]]
then
    exec fish
fi
EOF
    fi
}
