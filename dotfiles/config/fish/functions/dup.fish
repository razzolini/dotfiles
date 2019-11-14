function dup --description "Open another terminal window with the same working directory"
    urxvt -e fish &
    disown
end
