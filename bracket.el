;;; ~/.doom.d/bracket.el -*- lexical-binding: t; -*-

;; Reset [ and ] so that unimpaired in the global map could work
(defmacro fix-bracket (m)
  `(map! :map ,m
         :mng "[" nil
         :mng "]" nil))

(when (featurep! :tools magit)
  (after! magit
    (fix-bracket magit-status-mode-map)
    (fix-bracket magit-diff-mode-map)))

(when (featurep! :lang racket)
  (after! racket-mode
    (fix-bracket racket-repl-mode-map)))

(when (featurep! :emacs dired +ranger)
  (after! ranger
    (fix-bracket ranger-normal-mode-map)))
