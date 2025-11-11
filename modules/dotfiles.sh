#!/usr/bin/env bash
# dotfiles.sh - Aplica dotfiles usando stow

apply_dotfiles() {
    echo "==> Aplicando dotfiles com stow..."

    DOTFILES_DIR="$HOME/dotfiles"

    # Verificar se o diretório de dotfiles existe
    if [ ! -d "$DOTFILES_DIR" ]; then
        echo "  AVISO: Diretório $DOTFILES_DIR não encontrado"
        echo "  Pulando aplicação de dotfiles..."
        return 0
    fi

    cd "$DOTFILES_DIR"

    # Lista de módulos para aplicar com stow
    local modules=(
        "i3"
        "i3status"
        "picom"
        "clipcat"
    )

    # Aplicar cada módulo
    for module in "${modules[@]}"; do
        if [ -d "$module" ]; then
            echo "  -> Aplicando $module..."
            stow -t "$HOME" "$module" 2>/dev/null || true
        else
            echo "  AVISO: Módulo $module não encontrado, pulando..."
        fi
    done

    cd - > /dev/null

    echo "✓ Dotfiles aplicados com sucesso!"
}
