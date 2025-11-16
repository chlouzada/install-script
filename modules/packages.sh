#!/usr/bin/env bash
# packages.sh - Instalação de pacotes base

install_packages() {
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

#    echo "==> Instalando clipcat..."
#    if ! command -v clipcat &> /dev/null; then
#        CLIPCAT_VERSION=$(curl -s "https://api.github.com/repos/xrelkd/clipcat/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
#        curl -Lo /tmp/clipcat.tar.gz "https://github.com/xrelkd/clipcat/releases/download/v${CLIPCAT_VERSION}/clipcat-v${CLIPCAT_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
#        tar xf /tmp/clipcat.tar.gz -C /tmp
#        sudo install /tmp/clipcat-v${CLIPCAT_VERSION}-x86_64-unknown-linux-gnu/bin/clipcatd /usr/local/bin/
#        sudo install /tmp/clipcat-v${CLIPCAT_VERSION}-x86_64-unknown-linux-gnu/bin/clipcatctl /usr/local/bin/
#        sudo install /tmp/clipcat-v${CLIPCAT_VERSION}-x86_64-unknown-linux-gnu/bin/clipcat-menu /usr/local/bin/
#        rm -rf /tmp/clipcat.tar.gz /tmp/clipcat-v${CLIPCAT_VERSION}-x86_64-unknown-linux-gnu
#    fi

# Instalar Claude Code
    if ! command -v claude &> /dev/null; then
        curl -fsSL https://claude.ai/install.sh | bash &> /dev/null
    fi


    echo "✓ Pacotes instalados com sucesso!"
}
