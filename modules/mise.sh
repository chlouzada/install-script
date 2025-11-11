#!/usr/bin/env bash

setup_mise() {
    if ! command -v mise >/dev/null 2>&1; then
        curl https://mise.run | sh &> /dev/null
    fi

    if [ ! -x "$HOME/.local/bin/mise" ]; then
        exit 1
    fi

    BASH_RC="$HOME/.bashrc"
    FISH_RC="$HOME/.config/fish/config.fish"

    # Adiciona no .bashrc
    if ! grep -q 'mise activate bash' "$BASH_RC" 2>/dev/null; then
        echo 'eval "$(~/.local/bin/mise activate bash)"' >> "$BASH_RC"
    fi

    # Adiciona no config.fish
    mkdir -p "$(dirname "$FISH_RC")"
    if ! grep -q 'mise activate fish' "$FISH_RC" 2>/dev/null; then
        echo '~/.local/bin/mise activate fish | source' >> "$FISH_RC"
    fi

    [ -f "$BASH_RC" ] && . "$BASH_RC"
    if command -v fish >/dev/null 2>&1; then
        fish -c "source $FISH_RC" >/dev/null 2>&1 || true
    fi

    mise use -g node@latest &>/dev/null
    mise use -g go@latest &>/dev/null
}