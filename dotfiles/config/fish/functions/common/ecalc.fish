function ecalc --description "Use emacs as a CLI RPN calculator"
    # To get the right colors for a dark terminal background,
    # the Emacs background mode often has to be manually set to 'dark:
    # http://emacshorrors.com/posts/come-in-and-find-out.html
    emacs -Q -nw --eval "\
(progn
    (add-hook 'calc-end-hook 'kill-emacs)
    (setq frame-background-mode 'dark)
    (frame-set-background-mode (selected-frame))
    (full-calc))"
end
