;;; ~/.doom.d/lispy.el -*- lexical-binding: t; -*-

(defun significantp (old-point new-point)
  (not (or (equal old-point new-point)
           (equal (1+ old-point) new-point))))

(evil-define-motion my/lispyville-forward-sexp (count)
  "This is an evil motion equivalent of `forward-sexp'."
  (let ((original-point (point)))
    (when (nth 3 (syntax-ppss))
      (forward-char))
    (condition-case nil
        (forward-sexp (or count 1))
      (error nil))
    (unless (significantp original-point (point))
      (goto-char (1+ original-point))
      (condition-case nil
          (forward-sexp (or count 1))
        (error nil)))
    (backward-char)))

(evil-define-motion my/lispyville-backward-sexp (count)
  "This is an evil motion equivalent of `backward-sexp'."
  (let ((original-point (point)))
    (forward-char)
    (when (nth 3 (syntax-ppss))
      (backward-char))
    (condition-case nil
        (backward-sexp (or count 1))
      (error nil))
    (unless (significantp original-point (point))
      (goto-char original-point)
      (condition-case nil
          (backward-sexp (or count 1))
        (error nil)))))

(after! lispyville
  (map! :nmv "H" #'my/lispyville-backward-sexp
        :nmv "L" #'my/lispyville-forward-sexp
        :nmv "U" #'lispyville-backward-up-list)
  (lispyville-set-key-theme
   '((operators normal)
     (prettify insert)
     text-objects
     (atom-movement t)
     commentary))
  ;; so... show-smartparens-mode is still great, so we don't want to
  ;; deactivate smartparens-mode :(
  (remove-hook 'lispy-mode-hook #'turn-off-smartparens-mode))
