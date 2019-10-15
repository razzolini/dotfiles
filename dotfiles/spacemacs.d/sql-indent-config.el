(defun configure-sql-indentation ()
  "Configure the indentation settings for `sqlind-minor-mode'."
  (require 'sql-indent-left)
  (setq
   sqlind-basic-offset 2
   sqlind-indentation-offsets-alist `((in-select-clause +)
                                      (select-join-condition +)
                                      ,@sqlind-indentation-left-offsets-alist)))
(add-hook 'sqlind-minor-mode-hook 'configure-sql-indentation)
