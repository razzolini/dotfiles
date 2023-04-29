# Unfortunately, sending the whole command line (except the `b` function name) to bash and asking
# it to complete the last token wouldn't work reliably, due to syntax differences between fish and
# bash (e.g. command substitution). However, bash should be able to complete the first argument,
# i.e. the name of the bash command to execute (hereafter, the "subcommand"), which is the part I
# care about the most, since I'll mainly be using the `b` function to run bash aliases and
# functions. Then, the remaining arguments can just use the standard fish file completion, which is
# better than nothing.
#
# Another limitation is the fact that, as of fish 3.6.1, custom completions are incapable of
# handling entries that contain tabs or newlines, since those characters are used as separators by
# the completion mechanism and there's no way to escape them. Therefore, to be safe, any such
# entries returned by bash are discarded.

function _b_no_subcommand
    # This is a conservative check, which incorrectly returns false (i.e. "a subcommand has already
    # been specified") when the command line contains things that aren't arguments, such as
    # input/output redirections. However, as far as I can tell, there's no better way to do this,
    # short of implementing something close to a full parser for fish syntax.
    set --local already_complete_tokens (commandline --cut-at-cursor --current-process --tokenize)
    not set --query already_complete_tokens[2]
end

function _b_complete_subcommand
    # Hacky solution to get bash completions as a list.
    # Based on the last solution from https://stackoverflow.com/a/32523040

    # The current token may have unclosed quotes, but, thankfully, `string unescape` removes them.
    set --local incomplete_subcommand_name \
        (commandline --cut-at-cursor --current-token | string unescape | string collect --no-trim-newlines)

    # If the incomplete subcommand name entered by the user already contains tabs or newlines, then
    # all possible completion entries will also contain those characters, so the completion process
    # can be aborted early, because it would be unable to produce any valid entries, anyway.
    #
    # Note that `$incomplete_subcommand_name` always contains an extra trailing newline, which is
    # not actually present in the input, but is added by the `commandline` (and `string unescape`)
    # commands. This newline needs to be ignored when looking for actual newlines in the input, and
    # then needs to be removed.
    if string match --quiet --regex '[\t\n].*\n$' -- $incomplete_subcommand_name
        return
    end

    # Remove the aforementioned trailing newline.
    set incomplete_subcommand_name (string trim --right --chars \n -- $incomplete_subcommand_name)
    # If the string is now empty, convert it to an empty list to stop `_b_escape` from producing an
    # empty pair of single quotes, which would otherwise prevent bash from producing the list of all
    # available commands.
    if not string length --quiet -- $incomplete_subcommand_name
        set incomplete_subcommand_name
    end

    set --local escaped_subcommand_name (_b_escape $incomplete_subcommand_name)
    set --local insert_all_completions \e'*'
    set --local move_to_line_start \ca
    set --local print0_command_line_parts "bash -c -- $(_b_escape 'printf "%s\0" "$@"') bash"

    set --local bash_input \
        $escaped_subcommand_name $insert_all_completions \
        $move_to_line_start $print0_command_line_parts ' '

    # TERM=dumb is the easiest way to suppress the escape sequence used to set the window title.
    set --local bash_output (echo -ns $bash_input | TERM=dumb bash --login -i 2> /dev/null | string split0)

    # As mentioned above, discard entries that contain tabs or newlines.
    string match --entire --invert --regex '[\t\n]' -- $bash_output
end

complete --command b --condition _b_no_subcommand --no-files --arguments '(_b_complete_subcommand)'
