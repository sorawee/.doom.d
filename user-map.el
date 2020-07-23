;;; ~/.doom.d/user-map.el -*- lexical-binding: t; -*-

(defun my/fold ()
  (interactive)
  (set-selective-display (if selective-display
                             nil
                           (+ 1 (current-indentation)))))

(defun my/display-ansi-colors ()
  "Display ANSI colors"
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max)))

(map! :n "u" nil ;; replaced by C-/
      (:prefix "u"
       :nm "r" #'vr/query-replace
       :nm "f" #'my/fold
       :nm "c" #'my/display-ansi-colors))
