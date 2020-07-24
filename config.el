;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq! user-full-name "Sorawee Porncharoenwase"
       user-mail-address "sorawee.pwase@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq! doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq! org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq! display-line-numbers-type nil)


;; Here are some additional functions/macros that could help you configure Doom:
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
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(map! :map hydra-base-map
      "C-u" nil)

(load! "artist-mode")
(load! "bracket")
(load! "company")
(load! "latex")
(load! "paste-and-indent")
(load! "patch")
(load! "quit")
(load! "racket-mode")
(load! "swiper")
(load! "user-map")
(load! "window")
(load! "workspace")

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
       evil-want-minibuffer t)

(setq! visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(global-visual-line-mode t)

(add-hook! prog-mode #'display-fill-column-indicator-mode)

(defun my/insert-lambda ()
  "Insert the λ character"
  (interactive)
  (insert-char (string-to-char "λ") 1))

(map! :i "s-\\" #'my/insert-lambda
      :nim "s-q" "qz"
      :nim "s-w" "@z"
      :v "RET" #'evil-multiedit-toggle-or-restrict-region
      :v "s" #'evil-surround-region
      :m "j" #'evil-next-visual-line
      :m "k" #'evil-previous-visual-line
      :vn "<tab>" #'indent-for-tab-command
      :m "/" #'counsel-grep-or-swiper
      :i "C-h" #'left-char
      :i "C-j" #'next-line
      :i "C-k" #'previous-line
      :i "C-l" #'right-char
      :nm "[w" #'previous-multiframe-window
      :nm "]w" #'next-multiframe-window
      :m "[W" #'+workspace/switch-left
      :m "]W" #'+workspace/switch-right
      ;; replaced by j
      :m "gj" nil
      ;; replaced by k
      :m "gk" nil
      :mi "C-?" #'undo-fu-only-redo
      :n "gt" nil
      :n "gT" nil
      ;; replaced by s-/
      :nv "gc" nil
      ;; replaced by C-?
      :n "C-r" nil)


;; NOTE: please document what happens to the original functionality
(map! :leader
      :desc "Search project" "/" #'+default/search-project ;; override nothing
      "x" nil ;; replaced by SPC b s
      :desc "Jump to character" "SPC" #'avy-goto-word-or-subword-1
      (:prefix ("d" . "doom")
       :desc "Config file" "c" (cmd! (find-file "~/.doom.d/config.el"))
       :desc "Init file" "i" (cmd! (find-file "~/.doom.d/init.el"))
       :desc "Package file" "p" (cmd! (find-file "~/.doom.d/packages.el")))
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

(defmacro define-and-bind-text-object (key start-regex end-regex)
  "From https://stackoverflow.com/a/22418983/718349"
  (let ((inner-name (make-symbol "inner-name"))
        (outer-name (make-symbol "outer-name")))
    `(progn
       (evil-define-text-object ,inner-name (count &optional beg end type)
         (evil-select-paren ,start-regex ,end-regex beg end type count nil))
       (evil-define-text-object ,outer-name (count &optional beg end type)
         (evil-select-paren ,start-regex ,end-regex beg end type count t))
       (define-key evil-inner-text-objects-map ,key (quote ,inner-name))
       (define-key evil-outer-text-objects-map ,key (quote ,outer-name)))))

(define-and-bind-text-object "$" "\\$" "\\$") ;; for LaTeX

(after! evil-snipe
  (evil-snipe-mode -1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Pyret
(use-package! pyret
  :load-path "~/git/pyret-lang/tools/emacs"
  :mode ("\\.arr\\'" . pyret-mode))

(when (featurep! default +smartparens)
  (after! smartparens
    (show-smartparens-global-mode t)
    (custom-set-faces! `(sp-show-pair-match-face :foreground ,(doom-color 'green)
                                                 :inherit bold
                                                 :underline t))))


(map! (:when (featurep! :tools magit)
       (:after magit
        :map with-editor-mode-map
        :localleader
        :m "," #'with-editor-finish
        :m "k" #'with-editor-cancel))
      (:when (featurep! :ui tabs)
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
      (:when (featurep! :lang org)
       (:after evil-org
        :map evil-org-mode-map
        :i "C-l" nil
        :i "C-h" nil
        :i "C-j" nil
        :i "C-k" nil)))

;; Note:
;; brew install fd # for find file
;; brew install ripgrep # for search
;; brew install figlet # for artist mode
