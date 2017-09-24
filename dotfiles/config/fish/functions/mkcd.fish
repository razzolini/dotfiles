function mkcd --description 'Make a directory and cd to it'
    if test (count $argv) -ne 1
        echo Usage: mkcd DIR
        return 2
    end
    set -l dir $argv[1]
    mkdir -p $dir; and cd $dir
end
