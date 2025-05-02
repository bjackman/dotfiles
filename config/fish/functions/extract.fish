function extract
    if ! test -f $argv
        echo "'$argv' is not a valid file"
        return
    end
    switch $argv
        case "*.tar.bz2"
            tar xjvf $argv
        case "*.tar.gz"
            tar xzvf $argv
        case "*.tar.xz"
            tar xJvf $argv
        case "*.bz2"
            bunzip2 $argv
        case "*.rar"
            unrar e $argv
        case "*.gz"
            gunzip $argv
        case "*.tar"
            tar xf $argv
        case "*.tbz2"
            tar xjf $argv
        case "*.tgz"
            tar xzf $argv
        case "*.zip"
            unzip $argv
        case "*.Z"
            uncompress $argv
        case "*.7z"
            7z x $argv
        case "*.cpio.xz"
            xzcat $argv | cpio -idmv
        case "*"
            echo "'$argv' cannot be extracted via extract()" ;;
    end
end