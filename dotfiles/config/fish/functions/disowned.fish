function disowned --description 'Run a command in the background with suppressed IO and disown it'
    set -l escaped_argv (string escape --no-quoted -- $argv)
    # '&' must be part of the evaluated string, otherwise eval itself is run in
    # the background and the disown command is executed before the job is
    # created, therefore it acts on the wrong process.
    eval "$escaped_argv &" </dev/null >/dev/null ^&1
    disown
end

complete --command disowned --description 'Command to run' --exclusive --arguments "(__fish_complete_subcommand)"
