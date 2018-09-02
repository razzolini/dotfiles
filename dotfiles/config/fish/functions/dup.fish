function dup --description "Open another terminal window with the same working directory"
    xterm -e fish &
    disown
end
