;;; bracket.el -*- lexical-binding: t; -*-

;; Reset [ and ] so that unimpaired in the global map could work
(defmacro fix-bracket (m)
  `(map! :map ,m
         :mng "[" nil
         :mng "]" nil))

(when (modulep! :tools magit)
  (after! magit
    (fix-bracket magit-stash-mode-map)
    (fix-bracket magit-log-mode-map)
    (fix-bracket magit-status-mode-map)
    (fix-bracket magit-diff-mode-map)))

(when (modulep! :lang racket)
  (after! racket-mode
    (fix-bracket racket-repl-mode-map)))
