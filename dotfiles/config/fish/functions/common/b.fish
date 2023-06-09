function b --description 'Run a bash command or start bash as a login shell'
    if set --query argv[1]
        # Using this function isn't precisely equivalent to running a command in
        # bash directly -- for example, wildcards are still interpreted by fish
        # -- but it should be close enough for everyday usage.
        bash --login -i -c -- (_b_escape $argv)
    else
        bash --login
    end
end
