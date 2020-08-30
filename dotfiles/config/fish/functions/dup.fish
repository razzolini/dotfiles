function dup --description "Open another terminal window with the same working directory"
    alacritty -e fish &
    disown
end
