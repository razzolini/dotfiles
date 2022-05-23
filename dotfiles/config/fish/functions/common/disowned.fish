function disowned --description 'Run a command in the background with suppressed IO and disown it'
    set -l escaped_argv (string escape --no-quoted -- $argv)

    # '&' must be part of the evaluated string, otherwise eval itself is run in
    # the background and the disown command is executed before the job is
    # created, therefore it acts on the wrong process.
    eval "$escaped_argv &" </dev/null &>/dev/null

    # Use `disown` as correctly as possible, based on the example found in the
    # default fish `open` function (as of version 3.4.1), which is:
    #
    # > # Note: We *need* to pass $last_pid, or it will disown the last *existing* job.
    # > # In case xdg-open forks, that would be whatever else the user has backgrounded.
    # > #
    # > # Yes, this has a (hopefully theoretical) race of the PID being recycled.
    # > disown $last_pid 2>/dev/null
    #
    # However, this is not enough here, because the command that's executed in
    # the background could be any command, including ones (such as `true`) which
    # may terminate before the `disown` command is executed. In that case, the
    # `$last_pid` variable would become empty, therefore `disown` would behave
    # as if no arguments were passed to it, meaning that it would disown the
    # last existing job, which, as stated above, is wrong. To prevent this, the
    # value of `$last_pid` is saved, and then only passed to `disown` if it
    # isn't empty.
    set -l saved_last_pid $last_pid
    if test -n "$saved_last_pid"
        disown $saved_last_pid 2>/dev/null
    end
end

complete --command disowned --description 'Command to run' --exclusive --arguments "(__fish_complete_subcommand)"
