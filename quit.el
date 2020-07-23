;;; ~/.doom.d/quit.el -*- lexical-binding: t; -*-

;; In these buffers, we want q to quit-window
(defmacro fix-quit (m)
  `(map! :map ,m
         :n "q" #'quit-window))

(fix-quit messages-buffer-mode-map)

(when (featurep! :lang racket)
  (after! racket-mode
    (fix-quit racket-describe-mode-map)))
