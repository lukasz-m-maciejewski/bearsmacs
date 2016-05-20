;;; init.el --- emacs's initialize file
;;; Commentary:
;;; Code:

;; == Disable loading of "default.el" at startup ======================
(setq inhibit-default-init t)

;; == Turn off mouse interface early in startup to avoid momentary display =
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(defun bears-package-list ()
  "Function display all available packages."
  (interactive)
  (message (concat "[clang-format]"
                   "[company]"
                   "[flycheck]"
                   "[ggtags]"
                   "[glsl]"
                   "[ido]"
                   "[irony]"
                   "[ninja]"
                   "[ttcn3]"
                   "[yasnippet]"
                   "[rainbow-delimiters]"
                   "[powerline]"
                   "[elpy]")))

(defun bears-theme-list ()
  "Function display all available themes."
  (interactive)
  (message (concat "[warm-night]"
                   "[zenburn]"
                   "[dracula]"
                   "[solarized-light]"
                   "[solarized-dark]")))

(defun bears-configuration-list ()
  "Dispplay all available configurations."
  (interactive)
  (message (concat "[bears-lisp-configuration]"
                   "[bears-text-configuration]"
                   "[bears-c++-configuration]"
                   "[bears-python-configuration]")))

(defun bears-update ()
  "Function update packages."
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(defvar use-bears-default-packages nil)
(defvar use-bears-default-configurations nil)
(defvar bears-packages nil)
(defvar bears-default-packages '(clang-format
                                 company
                                 flycheck
                                 ggtags
                                 ido
                                 irony
                                 yasnippet
                                 rainbow-delimiters
                                 powerline))
(defvar bears-theme "")

(defadvice load-theme (before disable-themes-first activate)
  "Disable theme before load new one."
  "disable all active themes."
  (dolist (i custom-enabled-themes)
    (disable-theme i)))

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(setq-default major-mode 'text-mode)

;; == Enable visual feedback on selections =============================
(setq transient-mark-mode t)

;; == No splash screen please... jeez ==================================
(setq inhibit-startup-screen t)

;; == Disable window's pipe delay =====================================
(setq w32-pipe-read-delay 0)

;; == Short confirm ==
(fset 'yes-or-no-p 'y-or-n-p)

;; == Add .h files to c++-mode ========================================
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; == Default to unified diffs ========================================
(setq diff-switches "-u")

;; == Default to better frame titles ================================
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; == open window disable ==========================================
(setq split-height-threshold nil
      split-width-threshold nil)

;; == (set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>])) ==
(set-frame-parameter (selected-frame) 'alpha '(90 50))
(add-to-list 'default-frame-alist '(alpha 90 50))

;; == use Shift+arrow_keys to move cursor around split panes =========
(windmove-default-keybindings)

;; == Set auto save files directory =================================
(setq temporary-file-directory "~/.emacs.d/tmp/"
      auto-save-file-name-transforms '((".*" "~/.emacs.d/emacs-autosaves/" t))
      backup-directory-alist '((".*" . "~/.emacs.d/emacs-backups"))
      make-backup-files t
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t
      auto-save-timeout 20
      auto-save-interval 200
      delete-old-versions t)

(setq custom-safe-themes t)

;;; == load bears private config file ==
(add-to-list 'load-path "~/.emacs.d/private")

;;; == user config file ==
(unless (file-exists-p "~/.bearsmacs.el")
  (copy-file "~/.emacs.d/private/bears-user-file.el" "~/.bearsmacs.el"))

(load-file "~/.bearsmacs.el")

(bears-configurations)
(bears-user-init)

(require 'bears-packages)

(unless (string= bears-theme "")
  (load-file (format "~/.emacs.d/private/themes/bears-%s.el" bears-theme)))

(require 'bears-style)
(require 'bears-bind)
(require 'bears-configuration)

(when use-bears-default-configurations
  (add-hook 'emacs-lisp-mode-hook 'bears-lisp-configuration)
  (add-hook 'text-mode-hook 'bears-text-configuration)
  (add-hook 'c++-mode-hook 'bears-c++-configuration)
  (add-hook 'python-mode-hook 'bears-python-configuration))

(when use-bears-default-packages
  (while bears-default-packages
    (load-file
     (format "~/.emacs.d/private/packages/bears-%s.el"
             (pop bears-default-packages)))))

(while bears-packages
  (load-file
   (format "~/.emacs.d/private/packages/bears-%s.el" (pop bears-packages))))

(bears-user-config)

;;; init.el ends here
