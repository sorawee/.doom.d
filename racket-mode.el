;;; ~/.doom.d/racket-mode.el -*- lexical-binding: t; -*-

(defun my/racket-repl-clear ()
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

(when (featurep! :lang racket)
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
          :desc "Clear screen" "k" #'my/racket-repl-clear)

    ;; Racket
    (put 'generator 'racket-indent-function 1)
    (put 'place 'racket-indent-function 1)
    (put 'place/context 'racket-indent-function 1)
    (put 'match-define-values 'racket-indent-function 1)
    (put 'for/stream 'racket-indent-function 'racket--indent-for)
    (put 'for*/stream 'racket-indent-function 'racket--indent-for)
    (put 'test-suite 'racket-indent-function 1)

    ;; pae
    (put 'นิยาม 'racket-indent-function 1)
    (put 'จับค่า 'racket-indent-function 1)
    (put 'กรณี 'racket-indent-function 0)
    (put 'ฟังก์ชัน 'racket-indent-function 1)

    ;; Rosette
    (put 'when/null 'racket-indent-function 1)

    (put 'destruct 'racket-indent-function 1)
    (put 'destruct* 'racket-indent-function 1)
    (put 'for/all 'racket-indent-function 'racket--indent-for)
    (put 'for*/all 'racket-indent-function 'racket--indent-for)))
