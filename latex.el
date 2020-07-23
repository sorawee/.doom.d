;;; ~/.doom.d/latex.el -*- lexical-binding: t; -*-

(when (featurep! :lang latex)
  (setq! +latex-viewers '(pdf-tools))
  (map! (:after latex
         :map LaTeX-mode-map
         :localleader
         :desc "compile all" "c" #'TeX-command-run-all
         :desc "view" "v" #'pdf-sync-forward-search)))
