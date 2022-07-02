function pacdiff --wraps pacdiff
    set -l output_only_options -h --help -o --output
    for opt in $output_only_options
        if contains -- $opt $argv
            # Running as root is not required when pacdiff only produces output, but doesn't edit files
            command pacdiff $argv
            return
        end
    end

    # Run as root, use a three-way merge tool, and back up files when overwriting
    command sudo --preserve-env DIFFPROG=$HOME/.local/bin/pacdiff-merge3 -- pacdiff --backup $argv
end
