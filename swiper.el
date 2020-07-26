;;; ~/.doom.d/swiper.el -*- lexical-binding: t; -*-

;; use hydra to read actions
(setq ivy-read-action-function #'ivy-hydra-read-action)

;; we don't want undo history to select the second entry as default
(setq! counsel-yank-pop-preselect-last t)

(after! counsel
  (defun add-prompt (str)
    (concat
     ">"
     (substring
      (mapconcat
       (lambda (s) (concat "  " s))
       (split-string str "\n")
       "\n")
      1)
     "\n"))
  (defun my/counsel--yank-pop-format-function (cand-pairs)
    "Transform CAND-PAIRS into a string for `counsel-yank-pop'."
    (ivy--format-function-generic
     (lambda (str)
       (ivy--add-face
        (add-prompt (counsel--yank-pop-truncate str)) 'ivy-current-match))
     (lambda (str) (add-prompt (counsel--yank-pop-truncate str)))
     cand-pairs
     ""))
  (ivy-configure #'counsel-yank-pop
    :format-fn #'my/counsel--yank-pop-format-function))

(defun my/ivy-toggle ()
  "Mark or unmark the selected candidate."
  (interactive)
  (if (ivy--marked-p)
      (ivy--unmark (ivy-state-current ivy-last))
    (ivy--mark (ivy-state-current ivy-last))))


(defun my/yank-pop (&optional arg)
  "A version of yank-pop that inserts after the point"
  (interactive "P")
  (undo-boundary)
  (forward-char)
  (counsel-yank-pop arg))

(map! :leader
      ;; override nothing
      :desc "Kill ring" "y" #'my/yank-pop)

(map! (:when (featurep! :completion ivy)
       (:after ivy
        :map ivy-minibuffer-map
        (:prefix ","
         :desc "Hydra" :nm "," #'hydra-ivy/body
         :desc "Insert" :nm "p" #'ivy-insert-current
         :desc "Insert full" :nm "P" #'ivy-insert-current-full
         :desc "Dispatch done" :nm "o" #'ivy-dispatching-done
         :desc "Dispatch call" :nm "O" #'ivy-dispatching-call
         :desc "Done" :nm "m" #'ivy-done
         :desc "Call" :nm "M" #'ivy-call)
        "s-<return>" #'my/ivy-toggle
        :nm "<return>" #'ivy-done
        :ginm "C-d" #'ivy-scroll-up-command
        :ginm "C-u" #'ivy-scroll-down-command)))
