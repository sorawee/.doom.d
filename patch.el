;;; ~/.doom.d/patch.el -*- lexical-binding: t; -*-

(when (featurep! :editor evil)
  (defun evil-posn-x-y (position)
    "Return the x and y coordinates in POSITION.
This function returns y offset from the top of the buffer area including
the header line.

On Emacs 24 and later versions, the y-offset returned by
`posn-at-point' is relative to the text area excluding the header
line, while y offset taken by `posn-at-x-y' is relative to the buffer
area including the header line.  This asymmetry is by design according
to GNU Emacs team.  This function fixes the asymmetry between them.

Learned from mozc.el."
    (let ((xy (posn-x-y position)))
      (when header-line-format
        (setcdr xy (+ (cdr xy)
                      (or (and (fboundp 'window-header-line-height)
                               (window-header-line-height))
                          evil-cached-header-line-height
                          (setq evil-cached-header-line-height (evil-header-line-height))))))
      (when (fboundp 'window-tab-line-height)
        (setcdr xy (+ (cdr xy) (window-tab-line-height))))
      xy)))
