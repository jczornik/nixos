;; (setq shell-file-name "/bin/bash")
;; (setq exec-path (append exec-path '("~/.local/bin" "~/.cargo/bin")))

;;(yas-global-mode)

;; Add custom configs
;;(add-to-list 'load-path "~/.emacs.d/custom/")

;; Define the init file
;; (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; (when (file-exists-p custom-file)
;;   (load custom-file))

;; Define and initialise package repositories
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; use-package to simplify the config file
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure 't)

(setq warning-minimum-level :emergency)


;; keyboard-centric user interface
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(defalias 'yes-or-no-p 'y-or-n-p)

;; Don't show the splash screen
(setq inhibit-startup-message t)

;; Always disable line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

;; Remove trailing whitespace
(add-hook 'write-file-hooks 'delete-trailing-whitespace)

(use-package company
  :ensure t)

;; Graphical settings
(use-package gruber-darker-theme
  :ensure t)
(load-theme 'gruber-darker t)
(global-hl-line-mode 1)
(set-face-attribute 'default nil :font "Ubuntu Mono 18")
(if (daemonp)
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (set-face-attribute 'default nil :font "Ubuntu Mono 18"))))

;; Backup directory
(setq backup-directory-alist '(("." . "~/.emacs_saves")))

;; Enable ido
(use-package ido)
(ido-mode t)
(setq ido-use-filename-at-point 'guess)

;; Multiple cursors
(use-package multiple-cursors
  :ensure t
  :bind
  (("C-s-c C-s-c" . mc/edit-lines)
   ("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this)
   ("C-c C-<" . mc/mark-all-like-this)))

;; enable smax
(use-package smex
  :ensure t)
(global-set-key (kbd "M-x") 'smex)

(use-package gitlab-ci-mode
  :ensure t)

(use-package magit
  :ensure t)

;; (use-package vterm
;;   :ensure t)

(use-package dir-treeview
  :ensure t)

(use-package yasnippet
  :ensure t
  :config
  (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
  (yas-global-mode 1))

;; Window manager in emacs
;; (use-package exwm
;;   :ensure t
;;   :config (require 'exwm-my-config))

;; Dap mode
(use-package dap-mode
  :ensure t)

;; Python
(use-package pyvenv
  :ensure t
  :init
  (setenv "WORKON_HOME" "~/.pyenv"))

(use-package poetry
  :ensure t)

(use-package lsp-mode
  :ensure t)

(use-package lsp-pyright
  :ensure t
  :custom (dap-python-debugger 'debugpy)
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp 'pyrigth)))
  :config
  (require 'dap-python))

;; Powershell
(use-package powershell
  :ensure t)


;; TypeScript
(use-package typescript-mode
  :ensure t)

(use-package tide
  :ensure t)

(use-package dockerfile-mode
  :ensure t)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

;; if you use typescript-mode
(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; rust config
(use-package rust-mode
  :ensure t
  :init
  (setq indent-tabs-mode nil)
  (setq rust-format-on-save t)
  :config
  (prettify-symbols-mode)
  :hook (rust-mode . lsp))

;; golang config
(use-package go-mode
  :ensure t
  :hook (go-mode . lsp))

;; php config
(use-package php-mode
  :ensure t
  :hook (php-mode . lsp))

(use-package csharp-mode
  :ensure t
  :config
  ;; (setq lsp-enable-indentation nil)
  :hook (csharp-mode . lsp))

;; c config
(use-package helm-lsp
  :ensure t)

(add-hook 'c-mode-hook 'lsp)


;; org mode
(require 'ox-md)

(use-package restclient
  :ensure t)

(use-package editorconfig
 :ensure t
 :config
 (editorconfig-mode 1))

;; Quelpa
(unless (package-installed-p 'quelpa)
  (with-temp-buffer
    (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
    (eval-buffer)
    (quelpa-self-upgrade)))

(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(require 'quelpa-use-package)

(use-package nix-mode
  :mode "\\.nix\\'")

;; Copilot
;; (use-package copilot
;;  :quelpa (copilot :fetcher github
;;                    :repo "copilot-emacs/copilot.el"
;;                    :branch "main"
;;                    :files ("dist" "*.el")))
;; (add-hook 'prog-mode-hook 'copilot-mode)
;; (define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
;; (define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

(use-package terraform-mode
  :ensure t
  :hook (terraform-mode . lsp))

(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" . gfm-mode)
  :init
  (setq markdown-command "multimarkdown")
  (setq fill-column 80)
  :bind (:map markdown-mode-map
              ("C-c C-e" . markdown-do))
  :hook (auto-fill-mode))
