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
