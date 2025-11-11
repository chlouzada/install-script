# Fish shell configuration

# Disable greeting
set -g -x fish_greeting

# Environment variables
set -Ux FOO bar
set -Ux ANDROID_HOME $HOME/Android/Sdk
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/platform-tools

# Add local bin to PATH
fish_add_path $HOME/.local/bin

# Keybindings
bind \e\cf _fzf_search_dir          # Alt+Ctrl+F - Search directories
bind \e\cs _fzf_search_git_status   # Alt+Ctrl+S - Git status search
bind \e\cg lazygit                  # Alt+Ctrl+G - Open lazygit

# Load asdf if available
if test -n (command -v asdf)
    if test -f $HOME/.nix-profile/share/asdf-vm/asdf.fish
        source $HOME/.nix-profile/share/asdf-vm/asdf.fish
        source $HOME/.nix-profile/share/asdf-vm/completions/asdf.fish
    else if test -f $HOME/.asdf/asdf.fish
        source $HOME/.asdf/asdf.fish
    end
end

# fzf default options
if not set --query FZF_DEFAULT_OPTS
    set --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'
end

# Load aliases
set -l config_dir (dirname (status --current-filename))
if test -f "$config_dir/aliases.fish"
    source "$config_dir/aliases.fish"
end
