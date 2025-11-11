#!/usr/bin/env bash
# packages.sh - Instalação de pacotes base

install_packages() {
    echo "==> Instalando pacotes base via apt..."

    local apt_packages=(
        openssh-client
        fd-find
        ripgrep
        zip
        unzip
        jq
        
        rofi
        nitrogen
        bat
        apache2-utils
        kitty
        alacritty
    )

    sudo apt update -qq
    sudo apt install -y "${apt_packages[@]}" &> /dev/null

    # Criar symlinks para comandos com nomes diferentes no Ubuntu

    if ! command -v fd &> /dev/null && command -v fdfind &> /dev/null; then
        mkdir -p "$LOCAL_BIN"
        ln -sf "$(which fdfind)" "$LOCAL_BIN/fd"
    fi

    echo "==> Instalando GitHub CLI..."
    if ! command -v gh &> /dev/null; then
        type -p curl >/dev/null || sudo apt install curl -y
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update -qq
        sudo apt install gh -y &> /dev/null
    fi

    echo "==> Instalando lazygit..."
    if ! command -v lazygit &> /dev/null; then
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
        sudo install /tmp/lazygit /usr/local/bin
        rm /tmp/lazygit.tar.gz /tmp/lazygit
    fi

    echo "==> Instalando lazydocker..."
    if ! command -v lazydocker &> /dev/null; then
        curl -sSL "https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh" | bash
    fi

    echo "==> Instalando yt-dlp..."
    if ! command -v yt-dlp &> /dev/null; then
        sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
        sudo chmod a+rx /usr/local/bin/yt-dlp
    fi

    echo "==> Instalando tldr..."
    if ! command -v tldr &> /dev/null; then
        curl -sSL https://raw.githubusercontent.com/tldr-pages/tldr/main/tldr -o "$LOCAL_BIN/tldr"
        chmod +x "$LOCAL_BIN/tldr"
    fi

    echo "==> Instalando turso-cli..."
    if ! command -v turso &> /dev/null; then
        curl -sSfL https://get.tur.so/install.sh | bash
    fi

    echo "==> Instalando clipcat..."
    if ! command -v clipcat &> /dev/null; then
        CLIPCAT_VERSION=$(curl -s "https://api.github.com/repos/xrelkd/clipcat/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo /tmp/clipcat.tar.gz "https://github.com/xrelkd/clipcat/releases/download/v${CLIPCAT_VERSION}/clipcat-v${CLIPCAT_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
        tar xf /tmp/clipcat.tar.gz -C /tmp
        sudo install /tmp/clipcat-v${CLIPCAT_VERSION}-x86_64-unknown-linux-gnu/bin/clipcatd /usr/local/bin/
        sudo install /tmp/clipcat-v${CLIPCAT_VERSION}-x86_64-unknown-linux-gnu/bin/clipcatctl /usr/local/bin/
        sudo install /tmp/clipcat-v${CLIPCAT_VERSION}-x86_64-unknown-linux-gnu/bin/clipcat-menu /usr/local/bin/
        rm -rf /tmp/clipcat.tar.gz /tmp/clipcat-v${CLIPCAT_VERSION}-x86_64-unknown-linux-gnu
    fi

    echo "✓ Pacotes instalados com sucesso!"
}
