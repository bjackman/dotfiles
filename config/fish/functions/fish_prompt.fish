# These need to be exported since we run fish_vcs_prompt in a subprocess.
set --export __fish_git_prompt_show_informative_status 1
set --export __fish_git_prompt_showdirtystate 1
set --export __fish_git_prompt_showuntrackedfiles 1
set --export __fish_git_prompt_showcolorhints 1
set --export __fish_git_prompt_color_branch cyan
set --export __fish_git_prompt_char_cleanstate ""

set --export fish_prompt_hg_show_informative_status

set brendan_vcs_prompt_file /tmp/brendan_vcs_prompt-$fish_pid

# Best effort cleanup...
function __fish_prompt_cleanup --on-event fish_exit
    rm $brendan_vcs_prompt_file
end

function fish_prompt
    set --local _status $status
    if [ $_status != 0 ];
        set --function status_bit "$(set_color red)$_status$(set_color normal)"
    end
    set --local cwd_bit "$(set_color $fish_color_cwd)$(prompt_pwd --full-length-dirs 3)$(set_color normal)"
    if [ $SHLVL != "1" ]
        set --function shlvl_bit "$(set_color $fish_color yellow)<$SHLVL>$(set_color normal)"
    end
    set --function prompt_color normal
    if set -q IN_NIX_SHELL
        set --function nix_bit "$(set_color brblue)nix$(set_color normal)"
        set --function prompt_color "brblue"
    end
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
    echo -e "\n$(set_color -b brblack)$cwd_bit$brendan_vcs_prompt $shlvl_bit $duration_bit$status_bit$nix_bit\n$(set_color  $prompt_color)❯❯$(set_color normal)  "
end

# Useful for testing.
set --export brendan_sleep_before_prompt 0

# Empirically it it seems that the fish_prompt event does not fire when the
# prompt is repainted. This is useful - if we did this logic directly from the
# fish_prompt function then we'd get an infinite loop.
function __fish_prompt_update --on-event fish_prompt
    # Although this is an event handler we are still running "on the main
    # thread" (also determined empirically). So we run the prompt command in the
    # background and communicate the result via a file. A --universal variable
    # would also work, but then it dirties this repository.
    fish --private --command \
        "sleep $brendan_sleep_before_prompt; fish_vcs_prompt > $brendan_vcs_prompt_file" &
    function update_vcs_prompt --on-process-exit $last_pid
        set --global brendan_vcs_prompt (cat $brendan_vcs_prompt_file)
        # Update the prompt - this will call fish_prompt again.
        commandline --function repaint
    end
end