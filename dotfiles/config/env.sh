# Add local bin dir to PATH if it exists and isn't already in the path
readonly LOCAL_BIN_DIR="$HOME/.local/bin"
if [ -d "$LOCAL_BIN_DIR" ]; then
    case ":$PATH:" in
        *":$LOCAL_BIN_DIR:"*) ;;
        *) PATH="$LOCAL_BIN_DIR:$PATH" ;;
    esac
fi

{%@@ if profile == "work-mac" @@%}
# Set the locale so that the macOS clipboard works correctly within neovim.
#
# iTerm provides an option to set locale variables automatically. When this
# option is off, LC_CTYPE is set to 'en_US.UTF-8' and all other variables are
# unset (therefore they they default to the 'C' locale). When it's on, with my
# combination of country and language (Italy, English), LC_CTYPE is set to
# 'UTF-8' and all other variables are still unset. Neither of these settings
# makes the clipboard work correctly within neovim (it messes up non-ASCII
# characters), whereas setting LANG here makes it work regardless of iTerm's
# settings.
export LANG='en_GB.UTF-8'
{%@@ endif @@%}

# Use neovim as default editor
export EDITOR="$(which nvim)"
export VISUAL="$EDITOR"

# Set ripgrep config file path
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgreprc"

{%@@ if profile == "home-desktop" @@%}
# Set default hledger journal (most recent one, assuming YEAR.journal name format)
export LEDGER_FILE="$(find "$HOME/Documents/Accounting/" -type f -regex '.*/[0-9]+\.journal' \
    | sort -n -t '.' -k 1 | tail -n 1)"
{%@@ endif @@%}
