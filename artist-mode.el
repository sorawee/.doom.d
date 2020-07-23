;;; ~/.doom.d/artist-mode.el -*- lexical-binding: t; -*-

(setq artist-aspect-ratio 2)
(defun my/set-artist-aspect-ratio (aspect-ratio)
  (interactive (list (read-number "Aspect ratio: " artist-aspect-ratio)))
  (setq artist-aspect-ratio aspect-ratio))

(defhydra hydra-artist (:color pink)
  ("p" #'artist-select-op-pen-line "Pen" :column "Free form")
  ("s" #'artist-select-op-spray-can "Spray can")
  ("t" #'artist-select-op-text-overwrite "Text")
  ("f" #'artist-select-op-flood-fill "Fill")
  ("L" #'artist-select-op-straight-line "Line" :column "Line")
  ("P" #'artist-select-op-poly-line "Poly-line")
  ("r" #'artist-select-op-rectangle "Rectangle & Square" :column "Shape")
  ("e" #'artist-select-op-circle "Ellipse & Circle")
  ("E" #'artist-select-op-erase-rectangle "Erase" :column "Erase")
  ("V" #'artist-select-op-vaporize-lines "Vaporize")
  ("C" #'erase-buffer "Clear screen")
  ("x" #'artist-select-op-cut-rectangle "Cut" :column "Selection")
  ("c" #'artist-select-op-copy-rectangle "Copy")
  ("v" #'artist-select-op-paste "Paste")
  ("A" #'my/set-artist-aspect-ratio "Set aspect ratio" :column "Settings & Meta")
  ("." #'artist-select-fill-char "Set fill char")
  ("|" #'artist-select-line-char "Set line char")
  ("q" nil "Quit" :color blue))

(map! :map picture-mode-map
      :localleader
      :desc "Transient" "," #'hydra-artist/body)
