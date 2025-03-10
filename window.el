;;; window.el -*- lexical-binding: t; -*-

;; from @bmag
(defun my/window-layout-toggle ()
  "Toggle between horizontal and vertical layout of two windows."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((window-tree (car (window-tree)))
             (current-split-vertical-p (car window-tree))
             (first-window (nth 2 window-tree))
             (second-window (nth 3 window-tree))
             (second-window-state (window-state-get second-window))
             (splitter (if current-split-vertical-p
                           #'split-window-horizontally
                         #'split-window-vertically)))
        (delete-other-windows first-window)
        ;; `window-state-put' also re-selects the window if needed, so we don't
        ;; need to call `select-window'
        (window-state-put second-window-state (funcall splitter)))
    (error "Can't toggle window layout when the number of windows isn't two.")))

(defhydra hydra-window (:hint nil)
  ("{" evil-window-decrease-height "Decrease height" :column "Height")
  ("}" evil-window-increase-height "Increase height")
  ("[" evil-window-decrease-width "Decrease width" :column "Width")
  ("]" evil-window-increase-width "Increase width")
  ("q" nil "cancel" :column "Meta"))

(map! :leader
      (:prefix "w"
       "+" nil ;; replaced by SPC w .
       "<" nil ;; replaced by SPC w .
       ">" nil ;; replaced by SPC w .
       "c" nil ;; replaced by SPC w d
       "s" nil ;; replaced by SPC w -
       "v" nil ;; replaced by SPC w /
       "S" nil ;; replaced by SPC w -
       "C-s" nil ;; replaced by SPC w -
       "C-v" nil ;; replaced by SPC w /
       "C-S-s" nil ;; replaced by SPC w -
       "/" #'evil-window-vsplit ;; override nothing
       "-" #'evil-window-split ;; replaced by SPC w .
       "+" #'my/window-layout-toggle ;; override nothing
       ;; override nothing
       :desc "Resize" "." #'hydra-window/body))
