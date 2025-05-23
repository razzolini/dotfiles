#!/usr/bin/env python3

import os
import subprocess
import sys
from tempfile import NamedTemporaryFile
import termios
import tty


DOTEMACS_DIR = os.path.expanduser('~/.emacs.d/')
DOTSPACEMACS_TEMPLATE = 'core/templates/dotspacemacs-template.el'
OLD_DOTSPACEMACS_TEMPLATE_NAME_PATTERN = {'prefix': 'dotspacemacs-template-', 'suffix': '.old.el'}
DOTSPACEMACS = os.path.expanduser('~/.spacemacs.d/init.el')

NORMAL = '\x1b[0m'
BOLD = '\x1b[1m'
ITALIC = '\x1b[3m'
YELLOW_FG = '\x1b[33m'
CYAN_FG = '\x1b[36m'


def main():
    """Update spacemacs interactively."""
    print_step_title('Fetching')
    fetch()
    print()

    if not fetched_changes():
        print_ansi('No spacemacs changes', [BOLD])
        print('Update packages manually if you want to.')
        return

    print_step_title('Showing changes')
    print('Close the viewer to continue.')
    show_changes()
    print()

    dotfile_needs_merging = dotfile_template_changed()
    if dotfile_needs_merging:
        print_warning_title('Dotfile template changed')
        show_dotfile_template_changes()
        print_warning_body('These changes will need to be merged after the update.')
        print()

    if not prompt_stop_emacs_and_update():
        # Skip package update too, because it's (probably) not safe to
        # update packages without also updating spacemacs
        return
    print()

    print_step_title('Merging updates')
    merge_changes()
    print()

    if dotfile_needs_merging:
        if prompt_merge_dotfile():
            print()
            print_step_title('Merging dotfile template changes')
            print('Close the merge tool to continue.')
            merge_dotfile()
            dotfile_needs_merging = False
        print()

    print_step_title('Starting package update')
    start_package_update()
    print()

    if dotfile_needs_merging:
        print_ansi('Remember to merge dotfile template changes.', [BOLD, ITALIC, YELLOW_FG])


def fetch():
    """Fetch changes from the default remote repository."""
    run_in_dotemacs(['git', 'fetch'])


def fetched_changes():
    """Check whether there are any changes to be merged after fetching."""
    head = commit_hash('HEAD')
    fetch_head = commit_hash('FETCH_HEAD')
    return head != fetch_head


def commit_hash(revision):
    """Get the full commit hash for a (potentially symbolic) revision, as a string."""
    return run_in_dotemacs(['git', 'rev-parse', revision], capture_output=True, text=True) \
        .stdout \
        .strip()


def show_changes():
    """
    Show all fetched commits.

    Wait until the commit viewer is closed before returning.
    """
    run_in_dotemacs(['gitk', '..FETCH_HEAD'])


def dotfile_template_changed():
    """Check whether any changes to the dotfile template have been fetched."""
    result = run_in_dotemacs(
        ['git', 'diff', '--quiet', '..FETCH_HEAD', '--', DOTSPACEMACS_TEMPLATE],
        check=False,
    )
    if result.returncode not in [0, 1]:
        result.check_returncode() # Always raises an exception in this case
    return result.returncode == 1


def show_dotfile_template_changes():
    """Show fetched changes in the dotfile template."""
    run_in_dotemacs(['git', 'diff', '..FETCH_HEAD', '--', DOTSPACEMACS_TEMPLATE])


def prompt_stop_emacs_and_update():
    """
    Ask the user whether they want to update spacemacs.

    When there are emacs processes running, tell the user to stop them before
    updating, and repeat the prompt until they either stop such processes, or
    answer no.
    """
    running = running_emacs_processes()
    while True:
        if running:
            print_warning_title('One or more emacs processes are running')
            print(running, end='')
            print_warning_body('If you want to update, you have to stop them manually before you can continue.')
        answer = prompt_unbuffered('Do you want to update [y/n]?').lower()
        running = running_emacs_processes()
        if answer == 'y' and not running:
            return True
        elif answer == 'n':
            return False


def running_emacs_processes():
    """
    Return a string which shows all running emacs processes.

    If no emacs processes are running, return the empty string.

    The returned string is actually the raw shell command output. In this
    script, there's no reason to parse it, because then it would just have to
    be reformatted in pretty much the same way.
    """
    # On Linux, `pgrep --list-full` could be used instead of this pipeline, but
    # it's not available on macOS
    result = subprocess.run(
        f"pgrep -i emacs | xargs -r ps -o pid=,command= -p",
        shell=True,
        text=True,
        capture_output=True,
    )
    if result.returncode not in [0, 1]:
        result.check_returncode() # Always raises an exception in this case
    return result.stdout


def merge_changes():
    """Fast-forward merge the changes which have just been fetched."""
    run_in_dotemacs(['git', 'merge', '--ff-only', 'FETCH_HEAD'])


def prompt_merge_dotfile():
    """Ask the user whether they want to merge dotfile template changes now."""
    while True:
        answer = prompt_unbuffered('Do you want to merge dotfile template changes now [y/n]?').lower()
        if answer == 'y':
            return True
        elif answer == 'n':
            return False


def prompt_unbuffered(prompt):
    """Prompts the user to enter a single character using unbuffered input."""
    print_ansi(prompt, [BOLD], end=' ', flush=True)
    return unbuffered_input()


def unbuffered_input():
    """Read a single character from stdin, without waiting for the enter key."""
    # Adapted from http://code.activestate.com/recipes/134892/
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setcbreak(fd)
        ch = sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    # Echo the user input (to emulate what happens with buffered input)
    print(ch)
    return ch


def merge_dotfile():
    """Open a merge tool to let the user merge dotfile template changes."""
    with NamedTemporaryFile(**OLD_DOTSPACEMACS_TEMPLATE_NAME_PATTERN) as old_template:
        run_in_dotemacs(['git', 'show', f'HEAD@{{1}}:{DOTSPACEMACS_TEMPLATE}'], stdout=old_template)
        new_template_name = os.path.join(DOTEMACS_DIR, DOTSPACEMACS_TEMPLATE)
        subprocess.run(
            ['kdiff3', '--out', DOTSPACEMACS, '--', old_template.name, DOTSPACEMACS, new_template_name],
            stderr=subprocess.DEVNULL,
        )


def run_in_dotemacs(command, check=True, **subprocess_args):
    """
    Run a command with DOTEMACS_DIR as the working directory.

    Arguments are the same as subprocess.run(), except that exit code checking
    is enabled by default (check=True).
    """
    return subprocess.run(command, cwd=DOTEMACS_DIR, check=check, **subprocess_args)


def start_package_update():
    """
    Start spacemacs and issue a package update command.

    Return immediately, without waiting for the update to complete. Otherwise,
    this script wouldn't end until the user closed spacemacs (after updating),
    but they might want to edit something instead!
    """
    subprocess.Popen(['emacs', '--eval', '(configuration-layer/update-packages)'])


def print_step_title(title):
    """Print the title of a step of the update process, with appropriate formatting."""
    print_ansi(f'∙ {title}', [BOLD, CYAN_FG])


def print_warning_title(title):
    """Print the title of a warning message, with appropriate formatting."""
    print_ansi(f'→ {title}', [BOLD, YELLOW_FG])


def print_warning_body(body):
    """Print the body of a warning message, with appropriate formatting."""
    print_ansi(body, [ITALIC, YELLOW_FG])


def print_ansi(message, formatting, **print_args):
    """
    Apply some ANSI escape sequences while printing a message.

    Formatting is automatically reset at the end of the message.

    Any extra kwargs are passed directly to the standard print function.
    """
    print(''.join(formatting) + message + NORMAL, **print_args)


if __name__ == '__main__':
    main()
