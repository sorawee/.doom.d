;;; ~/.doom.d/lispy.el -*- lexical-binding: t; -*-

(defun significantp (old-point new-point)
  (not (or (equal old-point new-point)
           (equal (1+ old-point) new-point))))

;; from https://github.com/noctuid/lispyville/pull/49/files
(evil-define-motion my/lispyville-forward-atom-end (count)
  "Go to the next atom or comment end COUNT times."
  :type inclusive
  (or count (setq count 1))
  (forward-char)
  (if (< count 0)
      (lispyville-backward-atom-end (- count))
    (cl-dotimes (_ count)
      (let ((orig-pos (point)))
        (forward-symbol 1)
        (unless (and (ignore-errors (end-of-thing 'lispyville-atom))
                     (not (<= (point) orig-pos)))
          (goto-char orig-pos)
          (cl-return))))
    (backward-char)))

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
  (lispy-set-key-theme '(lispy c-digits))
  (map! (:map lispy-mode-map
         :nmv "H" #'my/lispyville-backward-sexp
         :nmv "L" #'my/lispyville-forward-sexp
         :nmv "E" #'my/lispyville-forward-atom-end
         :nmv "U" #'lispyville-backward-up-list)
        (:map lispy-mode-map-lispy
         "[" nil
         "]" nil
         "}" nil
         ":" nil))
  (lispyville-set-key-theme
   '((operators normal)
     (prettify insert)
     text-objects
     (atom-movement t)
     commentary))
  ;; so... show-smartparens-mode is still great, so we don't want to
  ;; deactivate smartparens-mode :(
  (remove-hook 'lispy-mode-hook #'turn-off-smartparens-mode))
