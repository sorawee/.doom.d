;;; ~/.doom.d/company.el -*- lexical-binding: t; -*-

(when (featurep! :completion company)
  (after! company
    (defun my/company-number ()
      "Forward to `company-complete-number'.

Unless the number is potentially part of the candidate.
In that case, insert the number.

Copied from https://oremacs.com/2017/12/27/company-numbers/"
      (interactive)
      (let* ((k (this-command-keys))
             (re (concat "^" (regexp-quote company-prefix) (regexp-quote k))))
        (if (or (cl-find-if (lambda (s) (string-match re s))
                            company-candidates)
                (> (string-to-number k)
                   (length company-candidates))
                (looking-back "[0-9]+\\.[0-9]*" (line-beginning-position)))
            (self-insert-command 1)
          (company-complete-number
           (if (equal k "0")
               10
             (string-to-number k))))))
    (mapc
     (lambda (x)
       (define-key company-active-map (format "%d" x) #'my/company-number))
     (number-sequence 0 9))

    (setq! company-show-numbers t)

    ;; We want to be able to ctrl-h and ctrl-l to move cursor in editing states,
    ;; but if company pops up, its keymap will interfere
    ;; so let's make it not interfere
    (map! :map company-active-map
          "C-h" nil)))
