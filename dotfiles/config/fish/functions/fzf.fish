function fzf --wraps fzf
    # Set custom key bindings
    command fzf --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all $argv
end
