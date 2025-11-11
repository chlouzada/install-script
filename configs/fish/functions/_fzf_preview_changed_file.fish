function _fzf_preview_changed_file
    set -f path_status $argv[1]
    set -f path (string unescape (string sub --start 4 $path_status))
    set -f index_status (string sub --length 1 $path_status)
    set -f working_tree_status (string sub --start 2 --length 1 $path_status)

    set -f diff_opts --color=always

    if test $index_status = '?'
        _fzf_report_diff_type Untracked
        _fzf_preview_file $path
    else if contains {$index_status}$working_tree_status DD AU UD UA DU AA UU
        _fzf_report_diff_type Unmerged
        git diff $diff_opts -- $path
    else
        if test $index_status != " "
            _fzf_report_diff_type Staged

            if test $index_status = R
                set -f orig_and_new_path (string split --max 1 -- ' -> ' $path)
                git diff --staged $diff_opts -- $orig_and_new_path[1] $orig_and_new_path[2]
                set path $orig_and_new_path[2]
            else
                git diff --staged $diff_opts -- $path
            end
        end

        if test $working_tree_status != ' '
            _fzf_report_diff_type Unstaged
            git diff $diff_opts -- $path
        end
    end
end
