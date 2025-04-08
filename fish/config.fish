if status is-interactive
    abbr --add fnd "find . -name"

    function newdir --wraps mkdir
        mkdir -p $argv
        cd $argv
    end
end

set PATH "$HOME/.cargo/bin:$PATH"
# Created by `pipx` on 2024-12-07 10:57:17
set PATH $PATH /home/brendan/.local/bin

set -u fish_color_autosuggestion "555\x1ebrblack"
set -u fish_color_cancel "\x2dr"
set -u fish_color_command "005fd7"
set -u fish_color_comment "990000"
set -u fish_color_cwd "green"
set -u fish_color_cwd_root "red"
set -u fish_color_end "009900"
set -u fish_color_error "ff0000"
set -u fish_color_escape "00a6b2"
set -u fish_color_history_current "\x2d\x2dbold"
set -u fish_color_host "normal"
set -u fish_color_host_remote "yellow"
set -u fish_color_normal "normal"
set -u fish_color_operator "00a6b2"
set -u fish_color_param "00afff"
set -u fish_color_quote "999900"
set -u fish_color_redirection "00afff"
set -u fish_color_search_match "bryellow\x1e\x2d\x2dbackground\x3dbrblack"
set -u fish_color_selection "white\x1e\x2d\x2dbold\x1e\x2d\x2dbackground\x3dbrblack"
set -u fish_color_status "red"
set -u fish_color_user "brgreen"
set -u fish_color_valid_path "\x2d\x2dunderline"
set -u fish_key_bindings "fish_default_key_bindings"
set -u fish_pager_color_completion "\x1d"
set -u fish_pager_color_description "B3A06D\x1eyellow"
set -u fish_pager_color_prefix "normal\x1e\x2d\x2dbold\x1e\x2d\x2dunderline"
set -u fish_pager_color_progress "brwhite\x1e\x2d\x2dbackground\x3dcyan"
set -u fish_pager_color_selected_background "\x2dr"

export EDITOR=vim

fish_add_path --prepend /usr/lib/ccache
fish_add_path --append /usr/games # For fortune
export CCACHE_SLOPPINESS=time_macros

abbr --add bat -- batcat
