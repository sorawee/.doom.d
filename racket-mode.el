;;; racket-mode.el -*- lexical-binding: t; -*-

(defun significantp (old-point new-point)
  (not (or (equal old-point new-point)
           (equal (1+ old-point) new-point))))

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

(defun my/racket-repl-clear ()
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

(when (modulep! :lang racket)
  (after! racket-mode
    (set-face-attribute 'racket-xp-unused-face nil
                        :strike-through nil
                        :underline '(:color "orange" :style wave))

    (map! :map racket-xp-mode-map
          :localleader
          :desc "next bound occurrence" "b" #'racket-xp-next-use
          :desc "previous bound occurrence" "B" #'racket-xp-previous-use
          :desc "documentation" "h" #'racket-xp-documentation)

    (map! :map racket-repl-mode-map
          :localleader
          :desc "Clear screen" "k" #'my/racket-repl-clear)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
