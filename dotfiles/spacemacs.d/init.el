;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
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
   ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     helm
     (auto-completion :variables
                      auto-completion-return-key-behavior nil
                      auto-completion-complete-with-key-sequence "jk")
     asm
     c-c++
     csv
     emacs-lisp
     finance
     git
     (haskell :variables haskell-completion-backend 'intero)
     idris
     (latex :variables latex-enable-auto-fill nil)
     markdown
     org
     python
     rust ; includes toml support
     (shell :variables shell-default-shell 'eshell)
     shell-scripts
     (spell-checking :variables spell-checking-enable-by-default nil)
     sql
     (syntax-checking :variables syntax-checking-enable-by-default nil)
     yaml
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(org-alert)
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and uninstall any
   ;; unused packages as well as their unused dependencies.
   ;; `used-but-keep-unused' installs only the used packages but won't uninstall
   ;; them if they become unused. `all' installs *all* packages supported by
   ;; Spacemacs and never uninstall them. (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil
   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'.
   dotspacemacs-elpa-subdirectory nil
   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
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
   ;; `recents' `bookmarks' `projects' `agenda' `todos'."
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))
   ;; True if the home buffer should respond to resize events.
   dotspacemacs-startup-buffer-responsive t
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light)
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '("Source Code Pro"
                               :size 13
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The key used for Emacs commands (M-x) (after pressing on the leader key).
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
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; If non nil `Y' is remapped to `y$' in Evil states. (default nil)
   dotspacemacs-remap-Y-to-y$ t
   ;; If non-nil, the shift mappings `<' and `>' retain visual state if used
   ;; there. (default t)
   dotspacemacs-retain-visual-state-on-shift t
   ;; If non-nil, J and K move lines up and down when in visual mode.
   ;; (default nil)
   dotspacemacs-visual-line-move-text nil
   ;; If non nil, inverse the meaning of `g' in `:substitute' Evil ex-command.
   ;; (default nil)
   dotspacemacs-ex-substitute-global nil
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil
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
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; Controls fuzzy matching in helm. If set to `always', force fuzzy matching
   ;; in all non-asynchronous sources. If set to `source', preserve individual
   ;; source settings. Else, disable fuzzy matching in all sources.
   ;; (default 'always)
   dotspacemacs-helm-use-fuzzy 'always
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-transient-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t
   ;; If non nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols nil
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; Control line numbers activation.
   ;; If set to `t' or `relative' line numbers are turned on in all `prog-mode' and
   ;; `text-mode' derivatives. If set to `relative', line numbers are relative.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; (default nil)
   dotspacemacs-line-numbers nil
   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."

  ;; Store custom settings in a different file
  (setq custom-file "~/.spacemacs.d/custom.el")
  (load custom-file)
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

  ;; Workaround for Spacemacs issue #9915
  ;; For the first frame, even if created with `emacsclient -a "" -c'
  (defun fix-evil-highlight-persist-face-first-frame ()
    (when (face-background 'evil-search-highlight-persist-highlight-face)
      (spacemacs//adaptive-evil-highlight-persist-face)
      (remove-hook 'evil-search-highlight-persist-hook 'fix-evil-highlight-persist-face)))
  (add-hook 'evil-search-highlight-persist-hook 'fix-evil-highlight-persist-face-first-frame)
  ;; For subsequent frames
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (spacemacs//adaptive-evil-highlight-persist-face)))

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
