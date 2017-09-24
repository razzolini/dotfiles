function ecalc --description "Use emacs as a CLI RPN calculator"
    emacs -Q -nw --eval "(progn (add-hook 'calc-end-hook 'kill-emacs) (full-calc))"
end
