(require 'sql-indent)

;; Define `sqlind-indentation-left-offsets-alist' if it's not available,
;; otherwise, use the version from the package, which might have useful updates.
(unless (require 'sql-indent-left nil t)
  ;; The following code is copied from
  ;; https://github.com/alex-hhh/emacs-sql-indent/blob/1bb06f8d11188c3954bd1fb928e2084890397806/sql-indent-left.el

  (defun indent-case-statement-items (syntax base-indentation)
    "Look for a SYNTAX of ((block-start when) (in-block case \"\") ...)
or ((block-start else) (in-block case \"\") ...)."
    (let ((outer (sqlind-outer-context syntax)))
      (if (and (eq 'in-block (sqlind-syntax-symbol outer))
               (eq 'case (sqlind-syntax-keyword outer))
               (eq 'block-start (sqlind-syntax-symbol syntax))
               (memq (sqlind-syntax-keyword syntax) '(when else)))
          (+ base-indentation sqlind-basic-offset)
        base-indentation)))

  (defun sqlind-indent-select-column-alt (syntax base-indentation)
    "Return the indentation for a column after a SELECT DISTINCT clause.
SYNTAX is the syntax of the current line, BASE-INDENTATION is the
current indentation, which we need to update.
Like `sqlind-indent-select-column' but we try to align to the KEYWORD,
but if we are the first column after the SELECT clause we simply
add `sqlind-basic-offset'."
    (save-excursion
      (goto-char (sqlind-anchor-point syntax))
      (when (looking-at "select\\s *\\(top\\s +[0-9]+\\|distinct\\|unique\\)?")
        (if (match-beginning 1)
            (goto-char (match-beginning 1))
          (goto-char (match-end 0))))
      (skip-syntax-forward " ")
      (if (or (looking-at sqlind-comment-start-skip)
              (looking-at "$"))
          (+ base-indentation sqlind-basic-offset)
        (current-column))))

  (defvar sqlind-indentation-left-offsets-alist
    `((select-clause 0)
      (insert-clause 0)
      (delete-clause 0)
      (update-clause 0)
      (case-clause-item-cont 0)
      (block-start indent-case-statement-items)
      (begin-block 0)
      (case-clause +)
      (package +)
      (package-body +)
      (statement-continuation + sqlind-adjust-operator)
      (nested-statement-open         1)
      (nested-statement-continuation 1)
      (nested-statement-close        sqlind-use-anchor-indentation)
      (string-continuation 0) ;; or should it be a beginning of line or aligned with the previous block ?
      ;; Anyway. It's really *BAD* to continue a string across lines.
      (select-column sqlind-indent-select-column-alt
                     sqlind-adjust-operator
                     sqlind-lone-semicolon)
      (select-column-continuation sqlind-indent-select-column-alt
                                  sqlind-adjust-operator
                                  sqlind-lone-semicolon)
      (in-select-clause sqlind-lineup-to-clause-end
                        sqlind-adjust-operator
                        sqlind-left-justify-logical-operator
                        sqlind-lone-semicolon)
      (in-delete-clause sqlind-lineup-to-clause-end
                        sqlind-adjust-operator
                        sqlind-left-justify-logical-operator
                        sqlind-lone-semicolon)
      (in-insert-clause +
                        sqlind-adjust-operator
                        sqlind-left-justify-logical-operator
                        sqlind-lone-semicolon)
      (in-update-clause sqlind-lineup-to-clause-end
                        sqlind-adjust-operator
                        sqlind-left-justify-logical-operator
                        sqlind-lone-semicolon)
      (select-table-continuation + sqlind-lone-semicolon)
      ;; rest picked up from the original indentation offsets
      ,@sqlind-default-indentation-offsets-alist)
    "Align sql code like this :
clear columns
set linesize 2500
set trimout on trimspool on
select DISTINCT
       atc.column_name,
       atc.data_type,
       data_length,
       data_precision,
       nullable,
       data_scale,
       nvl(substr(comments, 1, 100), atc.column_name) comments
from   all_tab_columns atc,
       all_col_comments acc
where  atc.owner       = acc.owner
and    atc.table_name  = acc.table_name
and    atc.column_name = acc.column_name
and    atc.owner       = user
and    atc.table_name  = 'MY_TABLE'
and    atc.column_name = p_column_name
and    not exists (select 1
                   from   all_tab_columns atc1,
                          all_col_comments acc1
                   where  atc1.owner       = acc1.owner
                   and    atc1.table_name  = acc1.table_name
                   and    atc1.column_name = acc1.column_name
                   and    atc1.owner       = atc.owner
                   and    atc1.table_name  = atc.table_name
                   and    acc1.column_name = acc.column_name)
;
delete from my_table mt
where col_1 = v_col1
and  (   col_2 = v_col2
       or col_3 = v_col3)
and   col_42 = '42'
;
update my_table
set    col1_has_a_long_name = value1,
       col2_is_short        = value2
where cond1 is not null
and  (   col_2 = v_col2
       or col_3 = v_col3)
and   col_42 = '42'
;
insert into xyzxx
          ( aaa, xxx, bbb, ccc,
            ddd, eee, fff, ggg,
            hhh )
select aaa,
       xxx,
       max (m.b1) as bbb,
       min (m.b1) as ccc,
       coalesce (max (n.c2), 0)  as ddd,
       coalesce (min (n.c2), 0)  as eee,
       max (m.b1) over ( partition by c2
                         order by aaa desc ) as fff,
       min (m.b1) over ( partition by c2
                         order by aaa desc ) as ggg,
       avg (n.c2) as hhh
from  (select * from (select aaa,
                             jjj + kkk  as b1,
                             row_number () over ( partition by qqq
                                                  order by rrr,
                                                  sss ) as rn
                      from mno)
       where rn = 1) m
        inner join (select aaa,
                           nnn + ooo as c2
                    from   pqr) n
        using (aaa),
group by aaa,
         xxx
order by xxx desc,
         aaa asc
;"))

(defun configure-sql-indentation ()
  "Configure the indentation settings for `sqlind-minor-mode'."
  (setq
   sqlind-basic-offset 2
   sqlind-indentation-offsets-alist
   `((in-select-clause +)
     (select-join-condition +)
     (nested-statement-open sqlind-use-anchor-indentation +)
     (nested-statement-continuation sqlind-use-anchor-indentation +)
     (create-statement 0) ;; For ALTER TABLE actions
     (in-update-clause +)
     (in-delete-clause +)
     ,@sqlind-indentation-left-offsets-alist)))

(add-hook 'sqlind-minor-mode-hook 'configure-sql-indentation)
