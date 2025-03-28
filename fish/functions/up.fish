function up --argument-name levels
    if test -n "$levels"
        for i in (seq (math $levels))
            cd ..
        end
    else
        set git_root (git rev-parse --show-toplevel)
        if [ $git_root = $PWD ]
            cd ..
        else
            cd $git_root
        end
    end
end