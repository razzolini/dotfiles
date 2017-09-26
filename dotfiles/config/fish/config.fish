# Disable greeting message
set fish_greeting

# Configure git prompt
# Information
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
# Colors
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red
# Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'

# Import bash environment variables
env -i HOME=$HOME bash -l -c 'export -p' \
    | sed -e '/PWD/d; /SHLVL/d; /PATH/s/"//g; /PATH/s/:/ /g; s/=/ /; s/^declare/set/' \
    | source

# Start ssh agent and/or load its environment vars if needed
set -l agent_output "$HOME/.ssh-agent-output"
if not pgrep -u $USER ssh-agent > /dev/null
    ssh-agent | sed -r 's/^([A-Z_]+)=([^;]+).*/set -x \1 \2/' > $agent_output
end
if test -z $SSH_AGENT_PID
    source $agent_output > /dev/null
end

# Start X at login on tty1
if status is-login; and test -z "$DISPLAY" -a $XDG_VTNR -eq 1
    exec startx -- -keeptty
end
