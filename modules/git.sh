#!/usr/bin/env bash
# git.sh - Configurações avançadas do Git

setup_git() {
    echo "==> Configurando Git..."

    # Configurações básicas (user)
    git config --global user.name "chlouzada"
    git config --global user.email "chlouzada@gmail.com"

    # Aliases
    echo "  -> Configurando aliases..."
    git config --global alias.co checkout
    git config --global alias.ci commit
    git config --global alias.undo '!f() { [[ "$1" == "--hard" ]] && git reset --hard HEAD~${2:-1} || git reset --soft HEAD~${1:-1}; }; f'

    # Init config
    echo "  -> Configurando init defaults..."
    git config --global init.defaultBranch main

    # Push config
    echo "  -> Configurando push defaults..."
    git config --global push.default simple
    git config --global push.autoSetupRemote true

    # URL rewrites
    echo "  -> Configurando URL rewrites..."

    # GitHub SSH instead of HTTPS for push
    git config --global url."git@github.com:".pushInsteadOf "https://github.com"

    # GitHub shortcuts
    git config --global url."git@github.com:".insteadOf "gh:"
    git config --global url."https://github.com/".insteadOf "gh/:"

    # GitLab shortcuts
    git config --global url."git@gitlab.com:".insteadOf "gl:"
    git config --global url."https://gitlab.com/".insteadOf "gl/:"

    # Eurekka (specific to user's work)
    git config --global url."git@gitlab.eurekka.technology:eurekka-equipe-interna/".insteadOf "eurekka:"

    echo "✓ Git configurado com sucesso!"
}
