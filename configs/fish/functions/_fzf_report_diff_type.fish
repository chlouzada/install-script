function _fzf_report_diff_type
    set -f diff_type $argv[1]
    set -f repeat_count (math 2 + (string length $diff_type))
    set -f line (string repeat --count $repeat_count ─)

    set_color yellow
    echo $diff_type
    set_color normal
end
