function dup --description "Open another terminal window with the same working directory"
    xterm -e fish --init-command 'cd '(string escape $PWD) &
    disown
end
