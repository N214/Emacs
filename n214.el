(package-initialize)

(defun open-init()
  (interactive)
  (find-file "~/.emacs.d/n214.org"))

;;(global-company-mode t) 

;;(require 'package)
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'init-ui)
(require 'init-better-default)
(require 'init-org)
(require 'init-packages)
(require 'custom)
(require 'init-keybindings)

(setq custom-file (expand-file-name "lisp/custom.el" user-emacs-directory))
(load-file custom-file)

(defun load-init ()
    "Reload init file"
    (interactive)
    (load-file "~/.emacs.d/n214.el"))

;;(require 'init-benchmarking)

(setq package-enable-at-startup nil)

;;---------------------------------------------------

;;Use package config

(eval-when-compile
  (require 'use-package))

(require 'diminish)
(require 'bind-key)

;; Package
;; Impossible to load theme on other file
;(load-theme 'monokai t)
(load-theme 'doom-molokai)
;(require 'moe-theme)
;(moe-light)

;(use-package ample-theme
;  :init (progn (load-theme 'ample t t)
;               (load-theme 'ample-flat t t)
;               (load-theme 'ample-light t t)
;               (enable-theme 'ample))
;  :defer t
;  :ensure t)
