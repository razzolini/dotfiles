;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press `SPC f e R' (Vim style) or
     ;; `M-m f e R' (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     (auto-completion :variables
                      auto-completion-return-key-behavior nil
                      auto-completion-complete-with-key-sequence "jk")
     asm
     c-c++
     csv
     emacs-lisp
     finance
     git
     helm
     (haskell :variables haskell-completion-backend 'intero)
     idris
     (latex :variables latex-enable-auto-fill nil)
     markdown
     multiple-cursors
     org
     python
     rust ; includes toml support
     (shell :variables shell-default-shell 'eshell)
     shell-scripts
     (spell-checking :variables spell-checking-enable-by-default nil)
     sql
     (syntax-checking :variables syntax-checking-enable-by-default nil)
     treemacs
     yaml
     )

   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   ;; To use a local version of a package, use the `:location' property:
   ;; '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '(org-alert)
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil then enable support for the portable dumper. You'll need
   ;; to compile Emacs 27 from source following the instructions in file
   ;; EXPERIMENTAL.org at to root of the git repository.
   ;; (default nil)
   dotspacemacs-enable-emacs-pdumper nil

   ;; Name of executable file pointing to emacs 27+. This executable must be
   ;; in your PATH.
   ;; (default "emacs")
   dotspacemacs-emacs-pdumper-executable-file "emacs"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=~/.emacs.d/.cache/dumps/spacemacs.pdmp
   ;; (default spacemacs.pdmp)
   dotspacemacs-emacs-dumper-dump-file "spacemacs.pdmp"

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style '(vim :variables
                                    vim-style-remap-Y-to-y$ t)

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.1)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font or prioritized list of fonts.
   dotspacemacs-default-font '("Source Code Pro"
                               :size 9.5
                               :weight normal
                               :width normal)

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' in OSX to obtain
   ;; borderless fullscreen. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols nil

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but lines are only visual lines are counted. For example, folded lines
   ;; will not be counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers nil

   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
  ;; Store custom settings in a different file
  (setq custom-file "~/.spacemacs.d/custom.el")
  (load custom-file)
  )

(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."
  (defun quit-or-kill-frame ()
    "Kill the current frame when in daemon mode, otherwise prompt to save and quit."
    (interactive)
    (if (daemonp)
        (call-interactively 'spacemacs/frame-killer)
      (call-interactively 'spacemacs/prompt-kill-emacs)))
  ;; Rebind `SPC q q' to avoid stopping the server by accident, while moving
  ;; `spacemacs/prompt-kill-emacs' to `SPC q Q' and `spacemacs/kill-emacs' to
  ;; `SPC q K' in order to still have them available
  (spacemacs/set-leader-keys
    "qq" 'quit-or-kill-frame
    "qQ" 'spacemacs/prompt-kill-emacs
    "qK" 'spacemacs/kill-emacs)

  ;; Activate visual line mode in every buffer
  (global-visual-line-mode t)

  ;; Make `à' and `ù' act as `[' and `]' respectively in normal and motion state bindings
  ;; (for Italian qwerty layout)
  (defun remap-square-bracket-commands (keymap)
    "Recursively map square bracket commands to `à' and `ù'.
The original mappings are not removed."
    (let* ((open-bracket-mapping (lookup-key keymap (kbd "[")))
           (closed-bracket-mapping (lookup-key keymap (kbd "]")))
           (prefix-maps (-filter 'keymapp (list open-bracket-mapping closed-bracket-mapping))))
      (dolist (prefix-map prefix-maps)
        (remap-square-bracket-commands prefix-map))
      (define-key keymap (kbd "à") open-bracket-mapping)
      (define-key keymap (kbd "ù") closed-bracket-mapping)))
  (remap-square-bracket-commands evil-normal-state-map)
  (remap-square-bracket-commands evil-motion-state-map)

  ;; Disable evil-escape while using multiple cursors
  ;; (see https://github.com/gabesoft/evil-mc/issues/27)
  (with-eval-after-load 'evil-mc
    (add-to-list 'evil-mc-incompatible-minor-modes 'evil-escape-mode))

  ;; Add keybinding to manually update local words for spell checking from buffer directives
  (defun update-local-words-from-buffer ()
    "Load new buffer-local word definitions from LocalWords directives."
    (interactive)
    (flyspell-accept-buffer-local-defs 'force))
  (spacemacs/set-leader-keys "Sl" 'update-local-words-from-buffer)

  (defun set-local-abbrevs (abbrevs)
    "Add ABBREVS to `local-abbrev-table' and make it buffer local.
ABBREVS should be a list of abbrevs as passed to `define-abbrev-table'.
The `local-abbrev-table' will be replaced by a copy with the new abbrevs added,
so that it is not the same as the abbrev table used in other buffers with the
same `major-mode'."
    (let* ((bufname (buffer-name))
           (hash (md5 bufname))
           (prefix-length (min (length bufname) (length hash)))
           (prefix (substring hash 0 prefix-length))
           (tblsym (intern (concat prefix "-abbrev-table"))))
      (set tblsym (copy-abbrev-table local-abbrev-table))
      (dolist (abbrev abbrevs)
        (define-abbrev (eval tblsym)
          (cl-first abbrev)
          (cl-second abbrev)
          (cl-third abbrev)))
      (setq-local local-abbrev-table (eval tblsym))))

  ;; Default to k&r style for C and C++
  (with-eval-after-load 'cc-mode
    (add-to-list 'c-default-style '(c-mode . "k&r")))

  ;; Auto-reload files in `doc-mode'
  (add-hook 'doc-view-mode-hook 'auto-revert-mode)

  ;; Insert a single ' character in Haskell mode
  (add-hook 'haskell-mode-hook
            (lambda ()
              (define-key evil-insert-state-local-map (kbd "C-'") (kbd "C-q '"))))

  ;; Associate more file extensions to `ledger-mode'
  (add-to-list 'auto-mode-alist '("\\.\\(h?ledger\\|journal\\)$" . ledger-mode))

  ;; Add hledger income statement to `ledger-mode' reports
  (with-eval-after-load 'ledger-report
    (add-to-list 'ledger-reports
                 '("income" "%(binary) -f %(ledger-file) incomestatement")
                 t))

  ;; Enable org agenda notifications
  (require 'org-alert)
  (advice-add 'org-alert-check :around
              ;; Correctly restore current buffer after `org-alert-check', even if it's a popwin popup
              (lambda (f &rest args)
                (save-window-excursion (apply f args)))
              '((name . "restore popup buffer")))
  (org-alert-enable)

  ;; Bind more `helm-org-rifle' commands
  (spacemacs/set-leader-keys "aor" nil)
  (spacemacs/declare-prefix "aor" "rifle")
  (spacemacs/set-leader-keys "aorr" 'helm-org-rifle)
  (spacemacs/set-leader-keys "aora" 'helm-org-rifle-agenda-files)
  (spacemacs/set-leader-keys "aorb" 'helm-org-rifle-current-buffer)
  (spacemacs/set-leader-keys "aord" 'helm-org-rifle-directories)
  (spacemacs/set-leader-keys "aorf" 'helm-org-rifle-files)
  (spacemacs/set-leader-keys "aoro" 'helm-org-rifle-org-directory)

  ;; Configure smart quotes for org export
  (with-eval-after-load 'ox
    (add-to-list 'org-export-smart-quotes-alist
                 '("it"
                   (primary-opening :latex "``")
                   (primary-closing :latex "''")
                   (secondary-opening :latex "`")
                   (secondary-closing :latex "'"))))

  (defun hide-non-exported-org-src (&optional cycle-status)
    "Hide `org-mode' src blocks if the code they contain isn't exported.
The optional argument CYCLE-STATUS allows this function to be added to
`org-cycle-hook': in this case, it will only hide blocks when the global
visibility state becomes SHOW ALL (that is, when CYCLE-STATUS is `off'), since
this change makes all blocks visible again."
    (when (or (not cycle-status)
              (eq 'all cycle-status))
      (org-block-map
       (lambda ()
         (when-let ((block-info (org-babel-get-src-block-info))
                    (header-args (cl-third block-info))
                    (exports (split-string (cdr (assoc :exports header-args)) " " t)))
           (when (or (member "results" exports)
                     (member "none" exports))
             (org-hide-block-toggle t)))))))
  (add-hook 'org-mode-hook 'hide-non-exported-org-src)
  (add-hook 'org-cycle-hook 'hide-non-exported-org-src)

  ;; Enable syntax checking by default in `python-mode'
  (add-hook 'python-mode-hook 'flycheck-mode)

  ;; Enable `sqlind-minor-mode' by default in `sql-mode'
  (add-hook 'sql-mode-hook 'sqlind-minor-mode)
  ;; Load indentation config
  (load-file "~/.spacemacs.d/sql-indent-config.el")

  (setq-default
   evil-escape-unordered-key-sequence t

   tab-width 4

   save-abbrevs nil ; Do not (ask to) save abbreviations on quit

   ;; Use system notifications for `org-alert'
   alert-default-style 'libnotify

   ;; `asm' layer
   nasm-basic-offset 4

   ;; `c-c++' layer
   c-basic-offset 4

   ;; `finance' layer (`ledger-mode')
   ;; Set up for hledger instead of ledger
   ledger-binary-path "hledger"
   ledger-mode-should-check-version nil
   ledger-init-file-name " "
   ledger-report-links-in-register nil ; Uses command line option not supported by hledger
   ;; Disable highlighting of transaction under point
   ledger-highlight-xact-under-point nil

   ;; `haskell' layer
   ;; Configure indentation
   haskell-indentation-layout-offset 4 ; data declaration body
   haskell-indentation-starter-offset 4 ; let and case bodies
   haskell-indentation-left-offset 4 ; do body
   haskell-indentation-where-pre-offset 2 ; where keyword

   ;; `org' layer
   ;; Respect the `vim-style-retain-visual-state-on-shift' setting
   evil-org-retain-visual-state-on-shift vim-style-retain-visual-state-on-shift
   ;; Configure indentation
   org-adapt-indentation nil ; Do not indent text inside sections
   ;; Add footnotes at the end of the current outline node
   org-footnote-section nil
   ;; Configure export settings (shared by all backends)
   org-export-default-language "it"
   org-export-with-smart-quotes t
   org-export-with-toc nil
   ;; Disable postamble (footer) in html export
   org-html-postamble nil
   ;; Configure latex preview and export
   org-latex-compiler "xelatex"
   org-preview-latex-default-process 'imagemagick ; dvipng doesn't support TikZ
   org-latex-listings 'minted ; requires -shell-escape
   org-latex-pdf-process '("%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
                           "%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
                           "%latex -shell-escape -interaction nonstopmode -output-directory %o %f")
   ))
