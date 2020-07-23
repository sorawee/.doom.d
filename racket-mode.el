;;; ~/.doom.d/racket-mode.el -*- lexical-binding: t; -*-

;; (after! flycheck
;;   (setq-default flycheck-disabled-checkers (add-to-list 'flycheck-disabled-checkers 'racket)))

(when (featurep! :lang racket)
  (after! racket-mode
    (remove-hook! racket-mode #'racket-smart-open-bracket-mode)

    ;; don't flood tooltip messages in the message buffer
    ;; (setq! racket-show-functions '(racket-show-pseudo-tooltip))
    (set-face-attribute 'racket-xp-unused-face nil
                        :strike-through nil
                        :underline '(:color "orange" :style wave))

    (map! :map racket-xp-mode-map
          :localleader
          :desc "next bound occurrence" "b" #'racket-xp-next-use
          :desc "previous bound occurrence" "B" #'racket-xp-previous-use
          :desc "documentation" "h" #'racket-xp-documentation)

    ;; Racket
    (put 'generator 'racket-indent-function 1)
    (put 'place 'racket-indent-function 1)
    (put 'place/context 'racket-indent-function 1)
    (put 'match-define-values 'racket-indent-function 1)
    (put 'for/stream 'racket-indent-function 'racket--indent-for)
    (put 'for*/stream 'racket-indent-function 'racket--indent-for)
    (put 'test-suite 'racket-indent-function 1)

    ;; Rosette
    (put 'when/null 'racket-indent-function 1)

    (put 'for/all 'racket-indent-function 'racket--indent-for)
    (put 'for*/all 'racket-indent-function 'racket--indent-for)))
