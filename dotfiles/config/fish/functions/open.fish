function open --description 'Open file in default application'
    # Based on the default open function provided by fish.

    if count $argv >/dev/null
        switch $argv[1]
            case -h --h --he --hel --help
                __fish_print_help open
                return 0
        end
    end

    for i in $argv
        if not test -e $i
            echo "open: file '$i' does not exist" >&2
            return 2
        end
    end

    if type -q -f xdg-open
        for i in $argv
            disowned xdg-open $i
        end
    else
        echo (_ 'No open utility found. Try installing "xdg-open" or "xdg-utils".')
    end
end
