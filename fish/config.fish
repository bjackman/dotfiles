if status is-interactive
    abbr --add fnd "find . -name"

    function newdir --wraps mkdir
        mkdir -p $argv
        cd $argv
    end
end

set PATH "$HOME/.cargo/bin:$PATH"