# These need to be exported since we run fish_git_prompt in a subprocess.
set --export __fish_git_prompt_show_informative_status 1
set --export __fish_git_prompt_showdirtystate 1
set --export __fish_git_prompt_showuntrackedfiles 1
set --export __fish_git_prompt_showcolorhints 1
set --export __fish_git_prompt_color_branch cyan

set brendan_git_prompt_file /tmp/brendan_git_prompt-$fish_pid

# Best effort cleanup...
function __fish_prompt_cleanup --on-event fish_exit
    rm $brendan_git_prompt_file
end

function fish_prompt
    printf "%s%s%s%s \$ " \
        (set_color $fish_color_cwd) $PWD (set_color normal) \
        $brendan_git_prompt
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