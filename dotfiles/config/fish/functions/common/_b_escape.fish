function _b_escape
    set --local escaped
    for arg in $argv
        set --append escaped (bash -c -- 'printf "%q" "$1"' bash $arg)
    end
    string join ' ' -- $escaped
end
