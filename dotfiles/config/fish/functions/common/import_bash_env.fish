function import_bash_env --description "Import environment variables from bash"
    # Variables which should not be imported
    set -l excluded PWD OLDPWD SHLVL

    env -i HOME=$HOME XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR bash --login -c 'export -p' \
    | while read --local var
        set -l match (string match --regex '^declare -x ([^=]+)(?:="(.+)")?$' $var)
        set -l name $match[2]
        set -l value $match[3]

        if contains $name $excluded
            continue
        end

        set --global --export $name $value
    end

    return 0
end
