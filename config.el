;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Sorawee Porncharoenwase"
      user-mail-address "sorawee.pwase@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; HACK: https://github.com/doomemacs/doomemacs/issues/7532
(add-hook 'doom-after-init-hook (lambda () (tool-bar-mode 1) (tool-bar-mode 0)))

;; This setq! block must be the first thing in the configuration so that
;; doom-localleader-key is setup properly

(setq! doom-localleader-key ","
       ;; we have a lot of memory, let's use it!
       kill-ring-max 1000
       ;; enable hjkl and arrows to cross lines
       evil-cross-lines t
       ;; make it so that pasting in visual mode doesn't copy
       evil-kill-on-visual-paste nil
       ;; make undo record more steps
       evil-want-fine-undo t
       ;; we always want C-g to be preserved for keyboard-quit
       evil-want-C-g-bindings nil
       ;; when we exit the insertion mode, we don't want the caret to move back
       evil-move-cursor-back nil
       ;; use evil in minibuffer
       evil-want-minibuffer t
       ;; free up "," for doom-localleader-key
       +evil-repeat-keys (cons ";" "?")
       ;; speed up long line
       bidi-inhibit-bpa t)

(map! (:when (modulep! :completion vertico)
       (:after vertico
        :map vertico-map
        "C-d" (cmd! (vertico-scroll-up 1))
        "C-u" (cmd! (vertico-scroll-down 1))))
      (:when (modulep! :ui tabs)
       (:after centaur-tabs
        :map centaur-tabs-mode-map
        "s-{" #'centaur-tabs-backward
        "s-}" #'centaur-tabs-forward
        "s-[" #'centaur-tabs-backward-group
        "s-]" #'centaur-tabs-forward-group
        "s-P" #'centaur-tabs-toggle-groups
        "C-c C-<left>" nil
        "C-c C-<right>" nil
        "C-c C-<up>" nil
        "C-c C-<down>" nil))
      (:when (modulep! :lang org)
       (:after evil-org
        :map evil-org-mode-map
        :i "C-l" nil
        :i "C-h" nil
        :i "C-j" nil
        :i "C-k" nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Setup hydra so that it can be used in various files

(map! :map hydra-base-map
      ;; we don't want C-u in hydra to invoke prefix argument thing
      "C-u" nil)

;; we want to pad the autogenerated doc a little bit for aesthetic
(defun my/hydra-key-doc-function (key key-width doc doc-width)
  (cond
   ((equal key " ") (format (format " %%-%ds " (+ 3 key-width doc-width)) doc))
   ((listp doc)
    `(format ,(format " %%%ds: %%%ds " key-width (- -1 doc-width)) ,key ,doc))
   (t (format (format " %%%ds: %%%ds " key-width (- -1 doc-width)) key doc))))
(setq hydra-key-doc-function #'my/hydra-key-doc-function)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Global config

;; fullscreen on startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; remove doom-guess-mode-h
(remove-hook 'after-save-hook #'doom-guess-mode-h)

;; Word wrap
(setq! visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(global-visual-line-mode t)

;; A line guide for "too many characters in a line"
(add-hook! prog-mode #'display-fill-column-indicator-mode)

(defun my/insert-lambda ()
  "Insert the λ character"
  (interactive)
  (insert-char (string-to-char "λ") 1))

(map! :i "s-\\" #'my/insert-lambda
      ;; C-d and C-u in insertion state are not useful, and in minibuffer
      ;; they take precedent over ivy scrolling, which is bad, so let's unset
      ;; them
      :i "C-d" nil
      :i "C-u" nil
      ;; shortcut for recording + using macros
      :inm "s-q" "qz"
      :inm "s-w" "@z"
      :v "RET" #'evil-multiedit-toggle-or-restrict-region
      :v "s" #'evil-surround-region
      ;; up and down arrow are still bound to evil-{next, previous}-line
      :nm "j" #'evil-next-visual-line
      :nm "k" #'evil-previous-visual-line
      :vn "<tab>" #'indent-for-tab-command
      (:when (modulep! :completion ivy)
        :nm "/" #'counsel-grep-or-swiper)
      :i "C-h" #'left-char
      :i "C-j" #'next-line
      :i "C-k" #'previous-line
      :i "C-l" #'right-char
      :nm "[w" #'previous-multiframe-window
      :nm "]w" #'next-multiframe-window
      :nm "[W" #'+workspace/switch-left
      :nm "]W" #'+workspace/switch-right
      ;; replaced by j
      :nm "gj" nil
      ;; replaced by k
      :nm "gk" nil
      :inm "C-?" #'undo-fu-only-redo
      :nm "gt" nil
      :nm "gT" nil
      ;; replaced by s-/
      :nmv "gc" nil
      ;; replaced by C-?
      :nm "C-r" nil
      ;; replaced by SPC b d
      :inm "s-k" nil)

(defun ediff-dotfile-and-template ()
  "ediff the current `dotfile' with the template"
  (interactive)
  (ediff-files
   "~/.config/doom/init.el"
   "~/.config/emacs/templates/init.example.el"))

(map! :leader
      :desc "Search project" "/" #'+default/search-project ;; override nothing
      "x" nil ;; replaced by SPC b s
      :desc "Jump to character" "SPC" #'avy-goto-word-or-subword-1
      (:prefix ("d" . "doom")
       :desc "Config file" "c" (cmd! (find-file "~/.config/doom/config.el"))
       :desc "Init file" "i" (cmd! (find-file "~/.config/doom/init.el"))
       :desc "Diff init file" "d" #'ediff-dotfile-and-template
       :desc "Package file" "p" (cmd! (find-file "~/.config/doom/packages.el")))
      (:prefix "b"
       "x" nil ;; replaced by SPC b s
       "X" nil ;; replaced by SPC b s
       "n" nil ;; replaced by ] b
       "p" nil ;; replaced by [ b
       "]" nil ;; replaced by ] b
       "[" nil ;; replaced by [ b
       "k" nil ;; replaced by SPC b d
       "l" nil ;; replaced by SPC b <tab>
       ;; override nothing
       :desc "Switch to last buffer" "<tab>"
       #'evil-switch-to-windows-last-buffer
       ;; replaced by s-S
       :desc "Popup scratch buffer" "s" #'doom/open-scratch-buffer
       :desc "Switch to scratch buffer" "C-s" (cmd! (switch-to-buffer "*scratch*"))
       ;; replaced by SPC RET
       :desc "Switch to messages buffer" "m" (cmd! (switch-to-buffer "*Messages*")))
      (:prefix "s"
       ;; replaced by SPC /
       "e" #'evil-multiedit-match-all))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (modulep! :config default +smartparens)
  (after! smartparens
    (show-smartparens-global-mode t)
    (custom-set-faces! `(sp-show-pair-match-face :foreground ,(doom-color 'green)
                                                 :inherit bold
                                                 :underline t))))


(map! (:when (modulep! :tools magit)
       (:after magit
        :map with-editor-mode-map
        :localleader
        :m "," #'with-editor-finish
        :m "k" #'with-editor-cancel))
      (:when (modulep! :ui tabs)
       (:after centaur-tabs
        :map centaur-tabs-mode-map
        "s-{" #'centaur-tabs-backward
        "s-}" #'centaur-tabs-forward
        "s-[" #'centaur-tabs-move-current-tab-to-left
        "s-]" #'centaur-tabs-move-current-tab-to-right
        "s-P" #'centaur-tabs-toggle-groups
        "C-c C-<left>" nil
        "C-c C-<right>" nil
        "C-c C-<up>" nil
        "C-c C-<down>" nil))
      (:when (modulep! :lang org)
       (:after evil-org
        :map evil-org-mode-map
        :i "C-l" nil
        :i "C-h" nil
        :i "C-j" nil
        :i "C-k" nil)))

(after! centaur-tabs
  (centaur-tabs-group-by-projectile-project))

;; Free up s for substitute
(after! evil-snipe
  (evil-snipe-mode -1))

;; (use-package! copilot
;;   :hook (prog-mode . copilot-mode)
;;   :bind (:map copilot-completion-map
;;               ("<tab>" . 'copilot-accept-completion)
;;               ("TAB" . 'copilot-accept-completion)
;;               ("C-TAB" . 'copilot-accept-completion-by-word)
;;               ("C-<tab>" . 'copilot-accept-completion-by-word)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Load files

(load! "bracket")
(load! "latex")
(load! "racket-mode")
(load! "workspace")
(load! "window")

;; (use-package! racket-mode
;;   :load-path "~/projects/racket-mode"
;;   :config
;;   (require 'racket-hash-lang)
;;   (add-to-list 'auto-mode-alist '("\\.rkt\\'" . racket-hash-lang-mode))
;;   (add-to-list 'auto-mode-alist '("\\.scrbl\\'" . racket-hash-lang-mode))
;;   (add-to-list 'auto-mode-alist '("\\.rhm\\'" . racket-hash-lang-mode)))


;; Note:
;; brew install fd # for find file
;; brew install ripgrep # for search
;; brew install figlet # for artist mode
