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
(setq doom-font (font-spec :family "DejaVu Sans Mono" :size 14)
      doom-variable-pitch-font (font-spec :family "DejaVu Sans" :size 14))

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
      "C-a" #'doom/backward-to-bol-or-indent
      [end] #'end-of-line
      "C-e" #'end-of-line)

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

;; Use function keys for common utilities
(map! "<f1>" #'+eshell/toggle
      "<f2>" #'+default/search-other-cwd
      "<f3>" #'+default/search-project)

;; Use function keys for Magit
(map! "<f6>" #'magit-dispatch
      "<f7>" #'magit-status
      "<f8>" #'magit-blame-addition
      "<f9>" #'magit-log-current
      "<f10>" #'magit-log-buffer-file)

;; Adjust Ivy completion to make more sense, see also:
;; https://oremacs.com/2019/06/27/ivy-directory-improvements/
(map! (:after ivy
       :map ivy-minibuffer-map
       "C-m" #'ivy-alt-done             ; BTW, C-m == RET
       "C-j" #'ivy-immediate-done))

;; Fix dumb stuff in Eshell
(after! eshell
  (setq +eshell-enable-new-shell-on-split nil
        eshell-scroll-to-bottom-on-input nil
        eshell-scroll-to-bottom-on-output nil)
  ;; Don't remove the modeline
  (remove-hook 'eshell-mode-hook #'hide-mode-line-mode)
  ;; For some crazy reason, this needs to be done every time
  (add-hook! 'eshell-mode-hook
    (map! :map eshell-mode-map
          "<up>" nil
          "<down>" nil
          "C-s" nil
          "C-c s" nil
          "C-c v" nil
          "C-c x" nil
          [remap split-window-below]  nil
          [remap split-window-right]  nil)))

;; Workaround for issue #3274
(setq-hook! 'lsp-managed-mode-hook
  flycheck-disabled-checkers '(c/c++-clang))

;; Use Google C++ Style by default
(use-package! google-c-style
  :hook (c++-mode . google-set-c-style))

;; Fix problems with aspell and the --run-together option. Also set the personal
;; dictionary to the "normal" location.
(after! ispell
  (setq ispell-program-name "aspell"
        ;; Notice the lack of "--run-together"
        ispell-extra-args '("--sug-mode=ultra")
        ispell-personal-dictionary (expand-file-name "~/.aspell.en.pws"))
  (ispell-kill-ispell t))

;; Disable smartparans, I find it usually more harmful than helpful
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

;; Don't continue comments by default (Look into binding this to a key later)
(setq +default-want-RET-continue-comments nil)

;; Customize Org's TODO keywords and templates
(after! org
  (setq org-todo-keywords
        '((sequence "TODO(t)" "PROG(p)" "WAIT(w)" "HOLD(h)"
                    "|" "DONE(d)" "CANC(c)" "PROJ(j)"))
        org-todo-keyword-faces
        '(("PROG" . +org-todo-active)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("PROJ" . +org-todo-project))
        org-capture-templates
        '(("t" "Personal TODO" entry
           (file+headline +org-capture-todo-file "Immediate Tasks")
           "* TODO %?" :prepend t)
          ("n" "Personal Notes" entry
           (file+headline +org-capture-notes-file "Captured Notes")
           "* %?" :prepend t)
          ;; Will use {project-root}/{todo,notes}.org, unless a
          ;; {todo,notes,changelog}.org file is found in a parent directory.
          ;; Uses the basename from `+org-capture-todo-file',
          ;; `+org-capture-changelog-file' and `+org-capture-notes-file'.
          ("p" "Templates for projects")
          ("pt" "Project-Local TODO" entry ; {project-root}/todo.org
           (file+headline +org-capture-project-todo-file "Immediate Tasks")
           "* TODO %?" :prepend t)
          ("pn" "Project-Local Notes" entry ; {project-root}/notes.org
           (file+headline +org-capture-project-notes-file "Captured Notes")
           "* %?" :prepend t)
          ;; Will use {org-directory}/{+org-capture-projects-file} and store
          ;; these under {ProjectName}/{Tasks,Notes} headings. They support
          ;; `:parents' to specify what headings to put them under, e.g.
          ;; :parents ("Projects")
          ("o" "Centralized templates for projects")
          ("ot" "Project TODO" entry
           (function +org-capture-central-project-todo-file)
           "* TODO %?"
           :heading "Tasks"
           :prepend t)
          ("on" "Project Notes" entry
           (function +org-capture-central-project-notes-file)
           "* %?"
           :heading "Notes"
           :prepend t))))
