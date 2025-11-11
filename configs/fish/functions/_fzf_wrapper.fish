function _fzf_wrapper
    set -f --export SHELL (command --search fish)

    if not set --query FZF_DEFAULT_OPTS
        set --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'
    end

    fzf $argv
end
