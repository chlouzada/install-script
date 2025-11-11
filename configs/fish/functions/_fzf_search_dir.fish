function _fzf_search_dir
    set -f fd_cmd (command -v fdfind || command -v fd || echo "fd")
    set -f --append fd_cmd --color=always --maxdepth=2 $fzf_fd_opts

    set -f fzf_arguments --multi --ansi $fzf_dir_opts $fzf_directory_opts -i
    set -f token (commandline --current-token)
    set -f expanded_token (eval echo -- $token)
    set -f unescaped_exp_token (string unescape -- $expanded_token)

    if string match --quiet -- "*/" $unescaped_exp_token && test -d "$unescaped_exp_token"
        set --append fd_cmd --base-directory=$unescaped_exp_token
        set --prepend fzf_arguments --prompt="Search Directory $unescaped_exp_token> " --preview="_fzf_preview_file $expanded_token{}"
        set -f file_paths_selected $unescaped_exp_token($fd_cmd 2>/dev/null | _fzf_wrapper $fzf_arguments)
    else
        set --prepend fzf_arguments --prompt="Search Directory> " --query="$unescaped_exp_token" --preview='_fzf_preview_file {}'
        set -f file_paths_selected ($fd_cmd . $HOME 2>/dev/null | _fzf_wrapper $fzf_arguments)
    end

    if test $status -eq 0
        commandline --current-token --replace -- (string escape -- $file_paths_selected | string join ' ')
    end

    commandline --function repaint
end
