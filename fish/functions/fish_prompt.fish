# These need to be exported since we run fish_git_prompt in a subprocess.
set --export __fish_git_prompt_show_informative_status 1
set --export __fish_git_prompt_showdirtystate 1
set --export __fish_git_prompt_showuntrackedfiles 1
set --export __fish_git_prompt_showcolorhints 1
set --export __fish_git_prompt_color_branch cyan
set --export __fish_git_prompt_char_cleanstate ""

set brendan_git_prompt_file /tmp/brendan_git_prompt-$fish_pid

# Best effort cleanup...
function __fish_prompt_cleanup --on-event fish_exit
    rm $brendan_git_prompt_file
end

function fish_prompt
    set --local _status $status
    if [ $_status != 0 ];
        set --function status_bit "$(set_color red)$_status$(set_color normal)"
    end
    set --local cwd_bit "$(set_color $fish_color_cwd)$(prompt_pwd --full-length-dirs 3)$(set_color normal)"
    # $CMD_DURATION is in ms.
    if [ $CMD_DURATION -gt 1000 ]
        # Stolen from https://github.com/jorgebucaran/hydro/blob/41b46a05c84a/conf.d/hydro.fish#L47
        set --local secs (math --scale=1 $CMD_DURATION/1000 % 60)
        set --local mins (math --scale=0 $CMD_DURATION/60000 % 60)
        set --local hours (math --scale=0 $CMD_DURATION/3600000)
        set --function duration_bit (set_color magenta)
        test $hours -gt 0 && set --function --append duration_bit $hours"h"
        test $mins  -gt 0 && set --function --append duration_bit $mins"m"
        test $secs  -gt 0 && set --function --append duration_bit $secs"s"
        set --function --append duration_bit (set_color normal)
    end
    # I have no idea why spaces are not needed here.
    echo -e "$cwd_bit$brendan_git_prompt$duration_bit$status_bit\n\$ "
end

# Empirically it it seems that the fish_prompt event does not fire when the
# prompt is repainted. This is useful - if we did this logic directly from the
# fish_prompt function then we'd get an infinite loop.
function __fish_prompt_update --on-event fish_prompt
    if [ "$brendan_git_prompt_skip" != "1" ]  # Avoid infinite recursion
        brendan_git_prompt_skip=1 fish --private --command "fish_git_prompt > $brendan_git_prompt_file" &
        function update_git_prompt --on-process-exit $last_pid
            set --global brendan_git_prompt (cat $brendan_git_prompt_file)
            # Update the prompt - this will call fish_prompt again.
            commandline --function repaint
        end
    end
end