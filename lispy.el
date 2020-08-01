;;; ~/.doom.d/lispy.el -*- lexical-binding: t; -*-

(defun significantp (old-point new-point)
  (not (or (equal old-point new-point)
           (equal (1+ old-point) new-point))))

;; from https://github.com/noctuid/lispyville/pull/49/files
(evil-define-motion my/forward-atom-end (count)
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

(evil-define-motion my/forward-sexp (count)
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

(evil-define-motion my/backward-sexp (count)
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

(evil-define-motion my/down-list (count)
  "This is an evil motion equivalent of `down-list'."
  (down-list (or count 1))
  (my/forward-sexp)
  (my/backward-sexp))

(evil-define-motion my/backward-up-list (count)
  "This is an evil motion equivalent of `backward-up-list'."
  (let ((original-point (point)))
    (my/backward-sexp)
    (let ((this-point (point)))
      (condition-case nil
          (backward-up-list (or count 1))
        (error nil))
      (when (equal this-point (point))
        (goto-char original-point)))))

(map! :nmv "H" #'my/backward-sexp
      :nmv "L" #'my/forward-sexp
      :nmv "E" #'my/forward-atom-end
      :nmv "U" #'my/backward-up-list
      :nmv "Y" #'my/down-list)

(after! lispyville
  (lispy-set-key-theme '())
  (lispyville-set-key-theme
   '((operators normal)
     (prettify insert)
     text-objects
     (atom-movement t)
     commentary)))

(after! lispy
  (remove-hook 'lispy-mode-hook #'turn-off-smartparens-mode)
  (add-hook 'lispy-mode-hook #'turn-on-smartparens-mode))
