function newdir --wraps mkdir
    mkdir $argv
    cd $argv[-1]
end