;; -*- lexical-binding: t; -*-

;; Key Bindings Overview:
;; - SPC g r: Find references
;; - SPC g d: Find definitions
;; - SPC C-p: Projectile find file
;; - SPC c a: Execute LSP code action
;; - SPC r n: Rename with LSP
;; - SPC <escape>: Go back to normal state in Evil mode
;; - SPC f: Custom projectile find file
;; - SPC s n: Run nushell

;; Basic Editor Settings
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 2)

;; Line Numbers
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; Word Wrapping
(setq-default truncate-lines nil)  ;; Disable line truncation
(global-visual-line-mode t)        ;; Enable visual line mode for soft wrapping

;; Disable Unnecessary UI Elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Backup Files
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; Autosave Files
(setq auto-save-file-name-transforms
  `((".*", temporary-file-directory t)))

;; Evil Mode for Vim-like Keybindings
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; General for Custom Key Bindings
(use-package general
  :config
  (general-evil-setup t)
  (general-define-key
   :states '(normal visual emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "g r" 'xref-find-references
   "g d" 'xref-find-definitions
   "C-p" 'projectile-find-file
   "c a" 'lsp-execute-code-action
   "r n" 'lsp-rename
   "<escape>" (lambda ()
                (interactive)
                (evil-normal-state)
                (evil-force-normal-state))
   "f" 'my-projectile-find-file
   "s n" 'nushell)
  ;; Custom cursor shapes
  (setq evil-normal-state-cursor 'box)
  (setq evil-insert-state-cursor 'bar)
  (setq evil-visual-state-cursor 'hollow))

;; Theme
(use-package doom-themes
  :config
  (load-theme 'doom-one t))

;; Diagnostics
(use-package flycheck
  :config
  (global-flycheck-mode)
  (setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list)
  (setq flycheck-indication-mode 'right-fringe))

;; LSP (Language Server Protocol) Integration
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Prefix for LSP commands
  :hook
  ((prog-mode . lsp)                ;; Enable LSP for programming modes
   (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq lsp-signature-auto-activate t)
  (setq lsp-diagnostics-provider :auto)
  (setq lsp-completion-provider :capf))

;; LSP UI Enhancements
(use-package lsp-ui
  :after lsp-mode
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-position 'top)
  (setq lsp-ui-sideline-enable nil)  ;; Disable sideline to avoid clutter
  (setq lsp-ui-flycheck-enable t)
  (setq lsp-ui-peek-enable t)
  (setq lsp-ui-doc-show-with-cursor t)  ;; Show doc with cursor
  ;; Enable diagnostics in a popup
  (setq lsp-ui-sideline-show-diagnostics t)
  ;; Show diagnostics at the bottom
  (setq lsp-ui-sideline-show-hover t)
  (setq lsp-ui-sideline-ignore-duplicate t)
  ;; Adjust the position of the diagnostics
  (setq lsp-ui-sideline-diagnostic-max-lines 10)  ;; Max number of lines to show for diagnostics
  (add-hook 'lsp-mode-hook #'lsp-ui-mode))

;; Company (Completion Framework)
(use-package company
  :config
  (global-company-mode)
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0))

;; Projectile (Project Management)
(use-package projectile
  :config
  (projectile-mode +1)
  (setq projectile-completion-system 'ivy))

;; Ivy (Completion and Search)
(use-package ivy
  :config
  (ivy-mode 1))

;; Which-Key (Keybinding Help)
(use-package which-key
  :config
  (which-key-mode))

;; Dashboard Configuration
(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)))
  (setq dashboard-banner-logo-title "Welcome to Emacs!")
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  ;; Show number of loaded packages
  (add-hook 'emacs-startup-hook
            (lambda ()
              (setq dashboard-footer-messages (list (format "Packages loaded: %d" (length package-activated-list)))))))

;; Set Bash as the default shell for NixOS
(setq explicit-shell-file-name "/run/current-system/sw/bin/bash")
(setq shell-file-name "bash")
(setq explicit-bash-args '("--noediting" "--login" "-i"))
(setenv "SHELL" shell-file-name)
(setenv "ESHELL" shell-file-name)

;; File searching adjustments using Bash on NixOS
(defun my-projectile-find-file ()
  "Find file in project using Bash shell on NixOS."
  (interactive)
  (let ((default-directory (or (projectile-project-root) default-directory)))
    (call-process shell-file-name nil t nil "-c" "find . -type f -print0 | xargs -0 -n1 basename")))

;; Shell mode configuration for NixOS
(use-package shell
  :config
  (setq shell-file-name "bash")
  (setq explicit-shell-file-name "/run/current-system/sw/bin/bash")
  (setq explicit-bash-args '("--noediting" "--login" "-i")))

;; Adjust for Nushell integration, using Bash on NixOS
(defun nushell ()
  "Run an inferior instance of Bash inside Emacs on NixOS."
  (interactive)
  (let* ((buffer (get-buffer-create "*shell*"))
         (default-directory (or (projectile-project-root) default-directory)))
    (unless (comint-check-proc buffer)
      (apply 'make-comint-in-buffer "shell" buffer (expand-file-name explicit-shell-file-name) nil explicit-bash-args))
    (pop-to-buffer-same-window buffer)))

;; Language Support
(use-package nix-mode
  :mode "\\.nix\\'")

(use-package rust-mode
  :hook (rust-mode . lsp))

(use-package web-mode
  :mode ("\\.html?\\'" "\\.css?\\'")
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(use-package typescript-mode
  :mode ("\\.tsx?\\'" "\\.jsx?\\'")
  :hook (typescript-mode . lsp))

(use-package svelte-mode
  :mode "\\.svelte\\'")

(use-package go-mode
  :mode "\\.go\\'"
  :hook (go-mode . lsp))

(use-package elisp-lint
  :hook (emacs-lisp-mode . lsp))

(use-package zig-mode
  :mode "\\.zig\\'")
