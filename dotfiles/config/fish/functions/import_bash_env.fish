function import_bash_env --description "Import environment variables from bash"
    # Variables which should not be imported
    set -l excluded PWD OLDPWD SHLVL
    # Special colon-separated variables which fish treats as lists
    set -l lists PATH CDPATH MANPATH

    env --ignore-environment HOME=$HOME bash --login -c 'export -p' \
    | while read -l var
        set -l match (string match --regex '^declare -x ([^=]+)(?:="(.+)")?$' $var)
        set -l name $match[2]
        set -l value $match[3]

        if contains $name $excluded
            continue
        end

        if contains $name $lists
            set value (string split ':' $value)
        end

        set --global --export $name $value
    end

    return 0
end
