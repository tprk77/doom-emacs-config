;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Tim Perkins"
      user-mail-address "code@tprk77.net")

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
(setq doom-theme 'doom-tomorrow-night)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


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
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Better for multi-monitor coding
(map! "C-x o" #'next-window-any-frame
      "C-x C-o" #'previous-window-any-frame)

;; Better home and end keys
(map! [home] #'doom/backward-to-bol-or-indent
      [end] #'doom/forward-to-last-non-comment-or-eol)

;; Unbind arrow keys
(map! (:after smartparens
       :map smartparens-mode-map
       "C-<right>" nil
       "M-<right>" nil
       "C-<left>" nil
       "M-<left>" nil))

;; Add alternate key for redo
(map! (:after undo-fu
       :map undo-fu-mode-map
       "C-?" #'undo-fu-only-redo))

;; Use function keys for Magit
(map! "<f6>" #'magit-dispatch
      "<f7>" #'magit-status
      "<f8>" #'magit-blame-addition
      "<f9>" #'magit-log-current
      "<f10>" #'magit-log-buffer-file)

;; Workaround for issue #3274
(setq-hook! '(lsp-managed-mode-hook)
  flycheck-disabled-checkers '(c/c++-clang))

;; Hook to fix C++ namespace indentation
(add-hook! 'c++-mode-hook (c-set-offset 'innamespace 0))
