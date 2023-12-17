set __fish_git_prompt_show_informative_status 1
set __fish_git_prompt_showdirtystate 1
set __fish_git_prompt_showuntrackedfiles 1
set __fish_git_prompt_showcolorhints 1

function fish_prompt
   printf "%s%s%s%s \$ " \
    (set_color $fish_color_cwd) $PWD (set_color normal) \
    (fish_git_prompt)
end