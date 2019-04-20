;;----------Package Manager---------------------
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
  )

   (require 'cl)

   (defvar nicolas/packages '(
			      company
			      monokai-theme
			      hungry-delete
			      smex
			      swiper
			      smartparens
			      web-mode
			      ) "Default packages") 
   ;;(setq package-selected-packages nicolas/packages)

   (defun nicolas/packages-installed-p ()
        (loop for pkg in nicolas/packages
            when (not (package-installed-p pkg)) do (return nil)
            finally (return t)))

;;---------popwin mode
(require 'popwin)
(popwin-mode t)

;;---------relative linum
;;(linum-relative-in-helm-p nil)
(global-linum-mode nil)
(linum-relative-toggle)

;;---------evil leader
(global-evil-leader-mode)
(evil-leader/set-leader ",")
(evil-leader/set-key "f" 'ranger)

;;---------evil-mode
(evil-mode t)
(require 'evil)
(setq evil-want-C-u-scroll t)
(evil-escape-mode t)
(setq-default evil-escape-key-sequence "jk")

;;----------ivy-mode
(ivy-mode 1)
(setq enable-recursive-minibuffers t)
(setq ivy-display-style 'fancy)

(use-package ivy :demand
      :config
      (setq ivy-use-virtual-buffers t
            ivy-count-format "%d/%d "))
(ivy-set-actions
  'counsel-find-file
  '(("d" delete-file "delete")))

;;-----------smex
(require 'smex) ; Not needed if you use package.el
(smex-initialize)


;;----------------------------------------------------------------------------------
;; (require 'helm)
;;(require 'helm-config)
;;  (helm-mode 1)
;;
;;(defun helm-ido-like-find-files-up-one-level-maybe ()
;;  (interactv)
;;  (if (looking-back "/" 1)
;;      (call-interactively 'helm-find-files-up-one-level)
;;    (delete-char -1)))
;;
;;
;;(defun helm-ido-like-find-files-navigate-forward (orig-fun &rest args)
;;  "Adjust how helm-execute-persistent actions behaves, depending on context."
;;  (let ((sel (helm-get-selection)))
;;    (if (file-directory-p sel)
;;        ;; the current dir needs to work to
;;        ;; be able to select directories if needed
;;        (cond ((and (stringp sel)
;;                    (string-match "\\.\\'" (helm-get-selection)))
;;               (helm-maybe-exit-minibuffer))
;;              (t
;;               (apply orig-fun args)))
;;      (helm-maybe-exit-minibuffer))))
;;
;;
;;(defun helm-ido-like-load-file-nav ()
;;  (advice-add 'helm-execute-persistent-action :around #'helm-ido-like-find-files-navigate-forward)
;;    ;; <return> is not bound in helm-map by default
;;  (define-key helm-map (kbd "<return>") 'helm-maybe-exit-minibuffer)
;;  (with-eval-after-load 'helm-files
;;    (define-key helm-read-file-map (kbd "<backspace>") 'helm-ido-like-find-files-up-one-level-maybe)
;;    (define-key helm-read-file-map (kbd "DEL") 'helm-ido-like-find-files-up-one-level-maybe)
;;    (define-key helm-find-files-map (kbd "<backspace>") 'helm-ido-like-find-files-up-one-level-maybe)
;;    (define-key helm-find-files-map (kbd "DEL") 'helm-ido-like-find-files-up-one-level-maybe)
;;
;;    (define-key helm-find-files-map (kbd "<return>") 'helm-execute-persistent-action)
;;    (define-key helm-read-file-map (kbd "<return>") 'helm-execute-persistent-action)
;;    (define-key helm-find-files-map (kbd "RET") 'helm-execute-persistent-action)
;;    (define-key helm-read-file-map (kbd "RET") 'helm-execute-persistent-action)))


;;----------------------------------------------------------------------------------


;;----------------------------------------------------------------------------------
;;(setq-default helm-M-x-fuzzy-match t)

;;--------auto_mode
(setq auto-mode-alist
      (append
       '(("\\.html\\'" . web-mode)
	 )
       auto-mode-alist))

;;----------Web mode config
(defun my-web-mode-indent-setup()
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(add-hook 'web-mode-hook 'my-web-mode-indent-setup)

(defun my-toggle-web-indent ()
  (interactive)
  ;; web developpement
  (if (or (eq major-mode 'js-mode ) (eq major-mode 'js2-mode))
      (progn
	(setq js-indent-level (if (= js-indent-level 2) 4 2))
	(setq js-basic-offset (if (= js-basic-offset 2) 4 2))))
  (if (eq major-mode 'web-mode)
      (progn (setq web-mode-markup-indent-offset (if (= web-mode-markup-indent-offset 2) 4 2))
	     (setq web-mode-css-indent-offset (if (= web-mode-css-indent-offset 2) 4 2))
	     (setq web-mode-code-indent-offset (if (= web-mode-code-indent-offset 2) 4 2))))
    (if (eq major-mode 'css-mode)
	(setq css-indent-offset (if (= css-indent-offset 2) 4 2)))
    (setq indent-tabs-mode nil))
(global-set-key (kbd "C-c t i") 'my-toggle-web-indent)

;;----------------js2-refractor
(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-m")

;;----------------consel js
(global-set-key (kbd "M-s i") 'counsel-imenu)

;;--------------------Expand region
(global-set-key (kbd "C-=") 'er/expand-region)

;;---------------------iedit
(global-set-key (kbd "M-s e") 'iedit-mode)

;;---------------------Powerline
(require 'powerline)
(powerline-default-theme)

(provide 'init-packages)