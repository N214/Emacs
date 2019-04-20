(package-initialize)

(defun open-init()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;;(global-company-mode t) 

;;(require 'package)
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'init-ui)
(require 'init-better-default)
(require 'init-org)
(require 'init-keybindings)
(require 'init-packages)
(require 'custom)
(setq custom-file (expand-file-name "lisp/custom.el" user-emacs-directory))
(load-file custom-file)


(setq package-enable-at-startup nil)

;;---------------------------------------------------

;; (unless (package-installed-p 'use-package)
;; (package-refresh-contents)
;; (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(require 'diminish)
(require 'bind-key)

;; Package
;; Impossible to load theme on other file
(load-theme 'monokai t)



(use-package which-key
  :ensure t
  :init
  (which-key-mode))


(electric-indent-mode)