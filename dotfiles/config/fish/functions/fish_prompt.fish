function fish_prompt --description 'Write out the prompt'
    # Save the exit status of the last command / pipeline of commands
    set -l last_pipestatus $pipestatus

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix '>'
    if contains -- $USER root toor
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    # Format the pipestatus
    set -l prompt_status (__fish_print_pipestatus \
        ' [' ']' '|' \
        (set_color $fish_color_status) (set_color --bold $fish_color_status) \
        $last_pipestatus)

    echo -n -s \
        (set_color $color_cwd) (prompt_pwd) (set_color normal) \
        (fish_vcs_prompt) (set_color $normal) \
        $prompt_status $suffix ' '
end
