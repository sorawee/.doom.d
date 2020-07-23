;;; ~/.doom.d/paste-and-indent.el -*- lexical-binding: t; -*-

;; From Spacemacs

(defcustom my/indent-sensitive-modes
  '(asm-mode
    coffee-mode
    elm-mode
    haml-mode
    haskell-mode
    slim-mode
    makefile-mode
    makefile-bsdmake-mode
    makefile-gmake-mode
    makefile-imake-mode
    python-mode
    yaml-mode)
  "Modes for which auto-indenting is suppressed."
  :type 'list)

(defcustom my/yank-indent-modes '(latex-mode)
  "Modes in which to indent regions that are yanked (or yank-popped).
Only modes that don't derive from `prog-mode' should be listed here."
  :type 'list)

(defcustom my/yank-indent-threshold 1000
  "Threshold (# chars) over which indentation does not automatically occur."
  :type 'number)

(defun my/yank-advised-indent-function (beg end)
  "Do indentation, as long as the region isn't too large."
  (if (<= (- end beg) my/yank-indent-threshold)
      (indent-region beg end nil)))

(defun my/yank-indent-region (yank-func &rest args)
  "If current mode is not one of my/indent-sensitive-modes
indent yanked text (with universal arg don't indent)."
  (evil-start-undo-step)
  (prog1
      (let ((prefix (car args))
            (enable (and (not (member major-mode my/indent-sensitive-modes))
                         (or (derived-mode-p 'prog-mode)
                             (member major-mode my/yank-indent-modes)))))
        (when (and enable (equal '(4) prefix))
          (setq args (cdr args)))
        (prog1
            (apply yank-func args)
          (when (and enable (not (equal '(4) prefix)))
            (let ((transient-mark-mode nil)
                  (save-undo buffer-undo-list))
              (my/yank-advised-indent-function (region-beginning)
                                               (region-end))))))
    (evil-end-undo-step)))

(dolist (func '(yank yank-pop))
  (advice-add func :around #'my/yank-indent-region))

(when (featurep! :editor evil)
  (dolist (func '(evil-paste-before evil-paste-after))
    (advice-add func :around #'my/yank-indent-region)))
