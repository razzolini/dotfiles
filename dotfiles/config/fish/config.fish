# Disable greeting message
set fish_greeting

# Disable shortening of path components in the prompt
set fish_prompt_pwd_dir_length 0

# Select vi editing mode
fish_vi_key_bindings
# Emulate vim's cursor shape behavior
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace underscore
set fish_cursor_replace_one underscore

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
set __fish_git_prompt_char_dirtystate 'Δ'
{%@@ if profile == "work-linux" @@%}
set __fish_git_prompt_char_stagedstate 's'
set __fish_git_prompt_char_untrackedfiles 'u'
set __fish_git_prompt_char_stashstate 'z'
{%@@ else @@%}
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
{%@@ endif @@%}

# Import bash environment variables
import_bash_env

{%@@ if profile not in ["work-mac", "work-linux"] @@%}
# Start ssh agent and/or load its environment vars if needed
set -l agent_output "$HOME/.ssh-agent-output"
if not pgrep -u $USER ssh-agent > /dev/null
    ssh-agent | sed -E 's/^([A-Z_]+)=([^;]+).*/set -x \1 \2/' > $agent_output
end
if test -z $SSH_AGENT_PID
    source $agent_output > /dev/null
end

# Start X at login on tty1
if status is-login; and test -z "$DISPLAY" -a $XDG_VTNR -eq 1
    exec startx -- -keeptty
end
# The script only continues if this shell didn't start X
{%@@ endif @@%}
