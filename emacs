;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; File name: ` ~/.emacs '
;;; ---------------------
;;;
;;; If you need your own personal ~/.emacs
;;; please make a copy of this file
;;; an placein your changes and/or extension.
;;;
;;; Copyright (c) 1997-2002 SuSE Gmbh Nuernberg, Germany.
;;;
;;; Author: Werner Fink, <feedback@suse.de> 1997,98,99,2002
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Test of Emacs derivates
;;; -----------------------

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(if (string-match "XEmacs\\|Lucid" emacs-version)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; XEmacs
  ;;; ------
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (progn
     (if (file-readable-p "~/.xemacs/init.el")
        (load "~/.xemacs/init.el" nil t))
  )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; GNU-Emacs
  ;;; ---------
  ;;; load ~/.gnu-emacs or, if not exists /etc/skel/.gnu-emacs
  ;;; For a description and the settings see /etc/skel/.gnu-emacs
  ;;;   ... for your private ~/.gnu-emacs your are on your one.
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (if (file-readable-p "~/.gnu-emacs")
      (load "~/.gnu-emacs" nil t)
    (if (file-readable-p "/etc/skel/.gnu-emacs")
    (load "/etc/skel/.gnu-emacs" nil t)))

  ;; Custum Settings
  ;; ===============
  ;; To avoid any trouble with the customization system of GNU emacs
  ;; we set the default file ~/.gnu-emacs-custom
  (setq custom-file "~/.gnu-emacs-custom")
  (load "~/.gnu-emacs-custom" t t)
;;;
)
;;;

;(add-to-list 'load-path (expand-file-name "~/emacs/site/jde/lisp"))
;(add-to-list 'load-path (expand-file-name "~/emacs/site/semantic"))
;(add-to-list 'load-path (expand-file-name "~/emacs/site/speedbar"))
;(add-to-list 'load-path (expand-file-name "~/emacs/site/elib"))
;(add-to-list 'load-path (expand-file-name "~/emacs/site/eieio"))

;(require 'jde)

(require 'ido)
(ido-mode t)

;;;;;;;;;;;;;;;;;;;;;;;
;;; My location for external packages.
(add-to-list 'load-path "~/.emacs.d/site-lisp")

;;; Setup initial emacs frames (windows) location and size
;; (setq default-frame-alist
;;       '((wait-for-wm . nil)
;;     (top . 0) (left . 0)
;;     (width . 85) (height . 40)
;;     (background-color . "gray15")
;;     (foreground-color . "limegreen")
;;     (cursor-color . "LightGoldenrod")
;;     (mouse-color . "yellow")
;;         ))
(setq initial-frame-alist
      '((top . 400) (left . 1600)
       (width . 200) (height . 100)
        )
      )

;; pdt site-lisp
(setq pdt-emacs-dir "/n/tech/emacs")
(setq pdt-emacs-site-lisp-dir (expand-file-name "site-lisp" pdt-emacs-dir))
(setq pdt-emacs-bin-dir (expand-file-name "bin" pdt-emacs-dir))
;; load pdt site-lisp
(let ((default-directory pdt-emacs-site-lisp-dir))
             (load (expand-file-name "subdirs.el")))
;; load standard pdt settings
(require 'pdt-basic)
;;(require 'pdt-irony)

;(require 'ethan-wspace)


;; Always ask before closing
(setq confirm-kill-emacs 'y-or-n-p)

;; ... or ask before closing when in windowed mode (not in terminal)
(if (display-graphic-p)
    (setq confirm-kill-emacs 'y-or-n-p))

;; Make additional variables (such as the kill-ring, search-ring) persist between sessions
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

;; If you prefer to generate backup files but don't want to pollute your directory, put them
;; in a single, centralized location
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; If you have own color scheme and don't like to use emacs default
;; I recommend to use this package:
;; http://www.emacswiki.org/cgi-bin/wiki.pl?ColorTheme
;(require 'color-theme)
;(color-theme-billw)
;(color-theme-calm-forest)
;(color-theme-charcoal-black)
;(color-theme-classic)
;(color-theme-gnome2)

;Color-theme plugin
;; (add-to-list 'load-path
;;              "~/emacs/color-theme")
;; (require 'color-theme)
;; (eval-after-load "color-theme"
;;   '(progn
;;      (color-theme-initialize)
;;      (color-theme-hober)))

;; (color-theme-classic)
;(load-theme 'zenburn)

;; LOADING CEDET
;(load-file "~/.emacs.d/cedet-1.1/common/cedet.el")
;;LOADING SEMANTIC
;;(semantic-load-enable-excessive-code-helpers)
;;(require 'semantic-ia)


;(if window-system
;    (color-theme-gtk-ide)  ;GUI
;  (color-theme-hober))     ;Console

; WindMove
(require 'windmove)
; shifted arrow keys
(windmove-default-keybindings)
;(windmove-default-keybindings 'meta)

(require 'multi-scratch)
;;;(require 'json-mdoe)


(defun json-format ()
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point) "python -m json.tool" (buffer-name) t)
    )
  )


;;; Excellent package for better scrolling in emacs
;;; should be default package. But now it can be downloaded
;;; from: http://user.it.uu.se/~mic/pager.el
(require 'pager)

(require 'projectile)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;;;; Parens ;;;;
;;; mic-paren.el is available at:
;;; http://www.docs.uu.se/~mic/emacs.shtml
; (Xlaunch (require 'mic-paren) (paren-activate))
;;; cparen.el is available at:
;;; http://www.hut.fi/u/rsaikkon/software/elisp/cparen.el
(require 'cparen)
(cparen-activate)
;(show-paren-mode t)
;;;; /Parens ;;;;
;;;;;;;;;;;;;;;;;;;;;;;

;CamelCase forward words
;(autoload 'camelCase-mode "~/emacs/camelcase/camelCase-mode.el" nil t)
;(add-hook 'find-file-hook '(lambda () (camelCase-mode 1)))

;; ;Perforce plugin
;; (add-to-list 'load-path
;;       "~/emacs/p4")
;; (require 'p4)
;; (p4-menu-add)

;Toggler (switch between header & source files)
(load-file "~/emacs/toggle/toggle-source.el")
(require 'toggle-source)

;; ;Turn on auto-insert on new files
;; (require 'autoinsert)
;; (auto-insert-mode)
;; (load-file "~/emacs/c++/c++-auto-insert.el")

;Auto-indent new lines
(add-hook 'c-mode-common-hook '(lambda ()
      (local-set-key (kbd "RET") 'newline-and-indent)))

;Use spaces not tabs for indentation
;(setq-default indent-tabs-mode nil)


(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; reuse existing buffer windows instead of creating new ones
(setq display-buffer-reuse-frames 1)


;Delete key delete blocks of text
(when (fboundp 'pending-delete-mode)
  (pending-delete-mode 1)
  (setq pending-delete-modeline-string ""))

;Scrolling
(set-scroll-bar-mode 'right)
(setq scroll-step 1)


;Don't create emacs stubs (filename~) files
;(setq make-backup-files nil)
(setq make-backup-files t)


;Highlight TODO / FIXME etc.
(custom-set-faces)
(add-hook 'c-mode-common-hook
               (lambda ()
                (font-lock-add-keywords nil
                 '(("\\<\\(FIXME\\|TODO\\|BUG\\)" 1 font-lock-warning-face t)))))

;Lua Mode
;; (add-to-list 'load-path "~/emacs/lua")
;; (autoload 'lua-mode "lua-mode" "Lua editing mode." t)

;;;; This snippet enables lua-mode
;; This line is not necessary, if lua-mode.el is already on your load-path
(add-to-list 'load-path "~/emacs/lua")
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;CPerl setup
(fset 'perl-mode 'cperl-mode) ; Use cperl-mode instead of perl-mode
(defun greg-perl-indent-setup ()
  (local-set-key (kbd "RET") 'newline-and-indent)
  (setq cperl-extra-newline-before-brace t)
  (setq cperl-indent-parens-as-block t)
  (setq cperl-indent-level 4)
  (setq cperl-continued-statement-offset 0)
  (cperl-set-style "linux"))
(add-hook 'cperl-mode-hook 'greg-perl-indent-setup)
(setq cperl-invalid-face nil) ; Turn off highlighting trailing spaces with underscores

;; ;File association mappings
;; (setq auto-mode-alist
;;       (append '(("\\.h$"     . c++-mode)
;;                 ("\\.cc$"    . c++-mode)
;;                 ("\\.def$"   . c++-mode)
;;                 ("\\.mk\\."  . makefile-gmake-mode)
;;                 ("GNUmakefile" . makefile-gmake-mode)
;;                 ("\\.lua$"   . lua-mode))
;;                auto-mode-alist))

;; ;Indention Behaviour
;; (setq c-basic-offset 4)
;; (setq c-default-style "ellemtel") ; Closest match to preferred brace style
;; (setq c-offsets-alist
;;   '(
;;     (access-label . /) ; '/' means basic-offset * -0.5
;; ;    (innamespace . *) ; '*' means basic-offset * 0.5
;;     (innamespace . [4]) ; fixed offset (regardless of namespace depth)
;;     (arglist-close . c-lineup-close-paren) ; Align the close-paren on a multi-line expression with the corresponding open-paren
;;    )
;; )



;; (defconst my-c-style
;;   '((c-tab-always-indent        . t)
;;     (c-comment-only-line-offset . 0)
;;     (c-hanging-braces-alist     . ((substatement-open after)
;;                                    (brace-list-open)))
;;     (c-hanging-colons-alist     . ((member-init-intro before)
;;                                    (inher-intro)
;;                                    (case-label after)
;;                                   (label after)
;;                                    (access-label after)))
;;     (c-cleanup-list             . (scope-operator
;;                                    empty-defun-braces
;;                                    defun-close-semi))
;;     (c-offsets-alist            . ((arglist-close . c-lineup-arglist)
;;                                    (substatement-open . 0)
;;                                    (case-label        . 2)
;;                                    (block-open        . 0)
;;                                    (knr-argdecl-intro . -)))
;;     (c-echo-syntactic-information-p . t)
;;     )
;;   "My C Programming Style")

;; ;; Customizations for all of c-mode, c++-mode, and objc-mode
;; (defun my-c-mode-common-hook ()
;;   ;; add my personal style and set it for the current buffer
;;   (c-add-style "PERSONAL" my-c-style t)
;;   ;; offset customizations not in my-c-style
;;   (c-set-offset 'member-init-intro '++)
;;   ;; other customizations
;;   (setq tab-width 2
;;         ;; this will make sure spaces are used instead of tabs
;;         indent-tabs-mode nil)
;;   ;; we like auto-newline and hungry-delete
;;   ;;(c-toggle-auto-hungry-state 1)
;;   ;; keybindings for all supported languages.  We can put these in
;;   ;; c-mode-base-map because c-mode-map, c++-mode-map, objc-mode-map,
;;   ;; java-mode-map, and idl-mode-map inherit from it.
;;   (define-key c-mode-base-map "\C-m" 'newline-and-indent)
;;   (define-key c-mode-base-map "\C-z" 'scroll-up)
;;   )

;; (add-hook 'c-mode-common-hook 'my-c-mode-common-hook)



;;; define some macros here
(defmacro GNUEmacs (&rest x)
  (list 'if (string-match "GNU Emacs" (version)) (cons 'progn x)))
(defmacro XEmacs (&rest x)
  (list 'if (string-match "XEmacs 21" (version)) (cons 'progn x)))

;;; keyboard binding
;; Ctrl-Tab: Switch Buffers
;; Ctrl-z: Undo
;; Ctrl-o: open file
;; f4:     close file
;; f1:     manual-entry help
;; f2:     help
;; f3:     Search
;; f5:     Enter the shell mode, run program
;; f6:     Find next error
;; Ctrl-f6 Find previous error
;; f7:     compile
;; Meta-g: Goto line
;; Home:   Beginning of the line
;; End:    End of the line
;; Ctrl-home: Beginning of the buffer
;; Ctrl-end:  End of the buffer

; Ctrl-Tab: switch buffers
(global-set-key [(control tab)] 'bury-buffer)
;; Here are some thing may be just good for me
; I don't really like use C-z, rebind it to "undo"
;; (global-unset-key "\C-z")
;; (global-set-key "\C-z" 'undo)
; Enter is pretty fine. So I don't need C-o
;; (global-unset-key "\C-o")
;; (global-set-key "\C-o" 'find-file)
;; (global-unset-key "\C-s")
;; (global-set-key "\C-s" 'save-buffer
;;                )

;; For GNUEmacs
(GNUEmacs
; f1 : help
(global-set-key [f1] 'manual-entry)
(global-set-key [(control f1)] 'webjump)
(global-set-key [f2] 'help)
; f3: search
(global-set-key [f3] 'isearch-forward)
; f4: kill buffer
(global-set-key [f4] 'kill-buffer)
; f5: in Visual Studio, f5 = debug run
(global-set-key [f5] 'gdb)
(global-set-key [\C-f5] 'eshell)
; find erors. No defual binding in Visual studio
(global-set-key [f6] 'next-error)
(global-set-key [\C-f6] 'previous-error)
; in Visual Studio, f7 = build
(global-set-key [f7] 'compile)
(global-set-key [f8] 'revert-buffer)
)

;; For XEmacs
(XEmacs
; f1 : help
(global-unset-key 'f1)
(global-set-key 'f1 'manual-entry)
(global-set-key [(control f1)] 'webjump)
(global-set-key 'f2 'help)
; f3: search
(global-unset-key 'f3)
(global-set-key 'f3 'isearch-forward)
; f4: kill buffer
(global-set-key 'f4 'kill-buffer)
; f5: in Visual Studio, f5 = debug run
(global-set-key 'f5 'gdb)
(global-set-key [(control f5)] 'eshell)
; find erors. No defual binding in Visual studio
(global-set-key 'f6 'next-error)
(global-set-key [(control f6)] 'previous-error)
; in Visual Studio, f7 = build
(global-set-key 'f7 'compile)
)


;; Make GNUEmacs and XEmacs compatiable
(GNUEmacs
 ;;; XEmacs Compatiable
 (global-font-lock-mode t)
 ; highlight it before select
 (transient-mark-mode t)
 (global-set-key [(meta g)] 'goto-line)
 (global-set-key [home] 'beginning-of-line)
 (global-set-key [end] 'end-of-line)
 (global-set-key [\C-home] 'beginning-of-buffer)
 (global-set-key [\C-end] 'end-of-buffer)
)

; font-lock-mode
(XEmacs
  (add-hook 'c-mode-hook 'turn-on-font-lock)
)

(setq font-lock-maximum-decoration t)

(XEmacs
 (require 'font-lock)
)

(setq minibuffer-max-depth nil)

; Show line and Column
(line-number-mode t)
(column-number-mode t)
(global-linum-mode 1) ; display line numbers in margin. Emacs 23 only.
(setq linum-format "%4d ")  

;; Cleanup white space
;;(add-hook 'after-save-hook 'whitespace-cleanup)

; Show time
(display-time)

; Don't show the GNU splash window
(setq inhibit-startup-message t)

; Make all "yes-or-no" prompts show y-or-n instead
(fset 'yes-or-no-p 'y-or-n-p)

; auto save
(auto-save-mode t)

;;; Selection
(setq x-select-enable-clipboard t)
(setq mouse-yank-at-point t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

(setenv "P4DIFF" "")


;;; Useful functions
; select all
; The hard one to decide. /C-a is used by beginning of the line.
(defun select-all()
  (interactive)
  (set-mark(point-min))
  (goto-char(point-max))
)

; convert dos (^M) end of line to unix end of line
(defun dos2unix()
  (interactive)
  (goto-char(point-min))
  (while (search-forward "\r" nil t) (replace-match ""))
)

; unix2dos
(defun unix2dos()
  (interactive)
  (goto-char(point-min))
  (while (search-forward "\n" nil t) (replace-match "\r\n"))
)

;(GNUEmacs
; (load "cua-mode")
; (CUA-mode t)
;)

;; (XEmacs
;;  (global-unset-key "\C-c")
;;  (global-set-key "\C-c" 'copy-region-as-kill)
;;  (global-unset-key "\C-v")
;;  (global-set-key "\C-v" 'yank)


;; )

(global-set-key (kbd "<f9>")  'delete-trailing-whitespace)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(show-trailing-whitespace t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )


(GNUEmacs

;(require 'color-theme)
;(color-theme-gnome2)

;; I want long lines to end with my character
(set-display-table-slot standard-display-table 'wrap ?\+)
(set-display-table-slot standard-display-table 'truncation ?\+)

)

;;; last line...
(message nil)
(custom-set-variables
 '(load-home-init-file t t))
(custom-set-faces)

;;Parentheses
(make-variable-buffer-local 'show-paren-delay)
;(show-paren-mode t)
(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching paren if on a paren otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
    ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
    (t (self-insert-command (or arg 1)))))

(global-set-key [?\C-c ?c] 'comment-region)

(add-hook 'c-mode-common-hook
  (lambda ()
    (which-function-mode t)))


(defun align-regexp-repeated (start stop regexp)
  "Like align-regexp, but repeated for multiple columns. See
http://www.emacswiki.org/emacs/AlignCommands"
  (interactive "r\nsAlign regexp: ")
  (let ((spacing 1)
        (old-buffer-size (buffer-size)))
    ;; If our align regexp is just spaces, then we don't need any
    ;; extra spacing.
    (when (string-match regexp " ")
      (setq spacing 0))
    (align-regexp start stop
                  ;; add space at beginning of regexp
                  (concat "\\([[:space:]]*\\)" regexp)
                  1 spacing t)
    ;; modify stop because align-regexp will add/remove characters
    (align-regexp start (+ stop (- (buffer-size) old-buffer-size))
                  ;; add space at end of regexp
                  (concat regexp "\\([[:space:]]*\\)")
                  1 spacing t)))

;; Org-mode
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c b") 'org-iswitchb)

;; Change org-mode bindings to not trample on windmove and tmux settings
(defun org-mode-bindings ()
  (define-key org-mode-map (kbd "C-v <left>") 'org-shiftleft)
  (define-key org-mode-map (kbd "C-v <right>") 'org-shiftright)
  (define-key org-mode-map (kbd "C-v <up>") 'org-shiftup)
  (define-key org-mode-map (kbd "C-v <down>") 'org-shiftdown)
  (local-set-key (kbd "C-c <left>") nil)
  (local-set-key (kbd "C-c <right>") nil)
  (local-set-key (kbd "C-c <up>") nil)
  (local-set-key (kbd "C-c <down>") nil)
)
(add-hook 'org-mode-hook 'org-mode-bindings)

;; stamp time and note when item was done
;(setq org-log-done 'time)
;(setq org-log-done 'note)
(setq org-startup-indented t)

(setq org-todo-keywords
      '((sequence "TODO(t)" "DONE(d)")))
;      '((sequence "TODO(t!)" "WAITING(w!)" "BLOCKED(b!)" "|" "DONE(d!)" "HAND-OFF(h!)")))
(custom-set-variables
;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
'(org-agenda-files (quote ("~/git/rushi/work.org"))))
(custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
)

;;(emacs-lisp-mode perl-mode cperl-mode python-mode makefile-mode sh-mode diff-mode)


;;; Well, it is good to have the same keybinding for commenting out
;;; region in all modes.

;(load "ginel-string")
;(defun toggle-header-source-file()
;  "Toggle between C++ .C file and its corresponding .H file"
;  (interactive)
;  (let ( (curr-buf-name (buffer-name)) )
;    (if (string-match "\\.C$" curr-buf-name)
;    (find-file (ginel-string-replace curr-buf-name "\\.C$" ".H"))
;      (if (string-match "\\.H$" curr-buf-name)
;      (find-file (ginel-string-replace curr-buf-name "\\.H$" ".C"))
;    "Cannot toggle between Header and Source file: Current buffer is neither a .C nor a .H file"
;    )
;      )
;    )
;  )
;(global-set-key "\C-xt" 'toggle-header-source-file)


;;; autoinsert C/C++ header
;(eval-after-load 'autoinsert
;  (define-auto-insert
;  (cons "\\.\\([Hh]\\|hh\\|hpp\\)\\'" "My C / C++ header")
;  '(
;    (let* ((noext (substring buffer-file-name 0 (match-beginning 0)))
;       (nopath (file-name-nondirectory noext))
;       (ident (concat (upcase nopath) "_H")))
;      (concat "#ifndef " ident "\n"
;          "#define " ident  " 1\n\n\n"
;          "\n\n#endif // " ident "\n"))
;    )))
;
;;; auto insert C/C++
;(eval-after-load 'autoinsert
;  (define-auto-insert
;    (cons "\\.\\([Cc]\\|cc\\|cpp\\)\\'" "My C++ implementation")
;    '(
;;     nil
;;    "// " (file-name-nondirectory buffer-file-name) "\n"
;;    "//\n"
;;    "// last-edit-by: <> \n"
;;    "// \n"
;;    "// Description:\n"
;;    "//\n"
;;    (make-string 70 ?/) "\n\n"
;    (let* ((noext (substring buffer-file-name 0 (match-beginning 0)))
;       (nopath (file-name-nondirectory noext))
;       (ident (concat nopath ".h")))
;      (if (file-exists-p ident)
;      (concat "#include \"" ident "\"\n")))
;;    (make-string 70 ?/) "\n"
;;    "// $Log:$\n"
;;    "//\n"
;    )))
;
;(eval-after-load 'autoinsert
;  '(define-auto-insert '(perl-mode . "Perl skeleton")
;     '("Description: "
;       "#!/usr/bin/env perl" \n
;       \n
;       "use strict;" \n
;       "use warnings;" \n \n
;       _ \n \n
;;       "__END__" "\n\n"
;;       "=head1 NAME" "\n\n"
;;       str "\n\n"
;;       "=head1 SYNOPSIS" "\n\n\n"
;;       "=head1 DESCRIPTION" "\n\n\n"
;;       "=head1 COPYRIGHT" "\n\n"
;;       "Copyright (c) " (substring (current-time-string) -4) " "
;;       (getenv "ORGANIZATION") | (progn user-full-name) "\n\n"
;;       "This library is free software; you can redistribute it and/or" "\n"
;;       "modify it under the same terms as Perl itself." "\n\n"
;;       "=cut" "\n"
;)))

;; ;; autoinsert C/C++ header
;; (define-auto-insert
;;   (cons "\\.\\([Hh]\\|hh\\|hpp\\)\\'" "My C / C++ header")
;;   '(nil
;;     (let* ((noext (substring buffer-file-name 0 (match-beginning 0)))
;;            (nopath (file-name-nondirectory noext))
;;            (ident (concat (upcase nopath) "_H")))
;;       (concat "#ifndef " ident "\n"
;;               "#define " ident  " 1\n\n\n"
;;               "\n\n#endif // " ident "\n"))
;;     ))

;; ;; auto insert C/C++
;; (define-auto-insert
;;   (cons "\\.\\([Cc]\\|cc\\|cpp\\)\\'" "My C++ implementation")
;;   '(nil
;; ;    "// " (file-name-nondirectory buffer-file-name) "\n"
;; ;    "//\n"
;; ;    "// last-edit-by: <> \n"
;; ;    "// \n"
;; ;    "// Description:\n"
;; ;    "//\n"
;; ;    (make-string 70 ?/) "\n\n"
;;     (let* ((noext (substring buffer-file-name 0 (match-beginning 0)))
;;            (nopath (file-name-nondirectory noext))
;;            (ident (concat nopath ".H")))
;;       (if (file-exists-p ident)
;;           (concat "#include \<" ident "\>\n")))
;; ;    (make-string 70 ?/) "\n"
;; ;    "// $Log:$\n"
;; ;    "//\n"
;;     ))


(put 'downcase-region 'disabled nil)
(setq pcomplete-ignore-case t)

(add-to-list 'load-path "~/.emacs.d/iedit")
(require 'iedit)
