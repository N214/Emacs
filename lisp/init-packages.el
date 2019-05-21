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

;; Bootstrap 'use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; To load newer version of org
(package-initialize)

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)
;;---------popwin mode
(require 'popwin)
(popwin-mode t)

;;---------relative linum
;;(linum-relative-in-helm-p nil)
(global-linum-mode nil)
(linum-relative-toggle)

;;---------evil-mode

(use-package evil
  :ensure t
  :init
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-maybe-remove-spaces t)
  :config
  (evil-mode 1)
  (evil-escape-mode 1))

(setq-default evil-escape-key-sequence "jk")

;;---------evil leader
(global-evil-leader-mode)
(evil-leader/set-leader ",")
(evil-leader/set-key "f" 'ranger)
(evil-leader/set-key "t" 'shell-pop)

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

;;-----------hungry delete
(require 'hungry-delete)
(global-hungry-delete-mode)

;;----------------------------------------------------------------------------------
(require 'helm)
(require 'helm-config)
(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 30)
(helm-autoresize-mode 1)
(helm-mode 1)

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)


;;; Make DEL/BACKSPACE delete one character or the last path (if before a '/')
;; from https://github.com/hatschipuh/better-helm
(defun my-dwim-helm-find-files-up-one-level-maybe ()
  (interactive)
  (if (looking-back "/" 1)
      (call-interactively 'helm-find-files-up-one-level)
    (delete-char -1)))
(bind-key "<backspace>" #'my-dwim-helm-find-files-up-one-level-maybe helm-read-file-map)
(bind-key "<backspace>" #'my-dwim-helm-find-files-up-one-level-maybe helm-find-files-map)
(bind-key "DEL" #'my-dwim-helm-find-files-up-one-level-maybe helm-read-file-map)
(bind-key "DEL" #'my-dwim-helm-find-files-up-one-level-maybe helm-find-files-map);

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
(setq-default helm-M-x-fuzzy-match t)

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

;;--------------------org-pomodoro
(require 'org-pomodoro)

;;--------------------yasnippets
;;(use-package yasnippet
;;  :ensure t
;;  :config
;;  (yas-reload-all)
;;  (add-hook 'prog-mode-hook #'yas-minor-mode))

;;--------------------pdf-tools

(use-package pdf-tools
  :mode ("\\.pdf$" . pdf-view-mode)
  :pin manual ;; manually update
  :config
 ;; initialise
 (pdf-tools-install)
 ;; open pdfs scaled to fit page
 (setq-default pdf-view-display-size 'fit-page)
 ;; automatically annotate highlights
 ;(setq pdf-annot-activate-created-annotations 0)
 ;; use normal isearch
 (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
 ;; turn off cua so copy works
 (add-hook 'pdf-view-mode-hook (lambda () (cua-mode 0)))
 (add-hook 'pdf-view-mode-hook (lambda() (linum-mode -1)))
 ;; more fine-grained zooming
 (setq pdf-view-resize-factor 1.1)
 ;; keyboard shortcuts
 (define-key pdf-view-mode-map (kbd "h") 'pdf-annot-add-highlight-markup-annotation)
 (define-key pdf-view-mode-map (kbd "t") 'pdf-annot-add-text-annotation)
 (define-key pdf-view-mode-map (kbd "D") 'pdf-annot-delete)

  (with-eval-after-load 'evil
      (progn
        (add-to-list 'evil-emacs-state-modes 'pdf-outline-buffer-mode)
        (add-to-list 'evil-emacs-state-modes 'pdf-view-mode))))

;;--------------------undo tree
(use-package undo-tree
  :config)
;;-------------------search mode
(use-package engine-mode
  :config
  ;;initialise
  (engine-mode t)
  (defengine duckduckgo
  "https://duckduckgo.com/?q=%s"
  :keybinding "d")) ;;C-x / d 

;;------------------elpy
(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  (exec-path-from-shell-copy-env "PATH")
  (setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")
  (with-eval-after-load 'python
  (remove-hook 'python-mode-hook #'python-setup-shell)))
;;------------------flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;;-------------------pip8
(require 'py-autopep8)
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

;;---------------------symon
  (require 'symon)
  (symon-mode t)

;;---------------------evil-magit
(require 'evil-magit)

;;--------------------evil-tabs
(global-evil-tabs-mode t)
(elscreen-toggle-display-tab)

;;-----------------------emms player
(require 'emms-setup)
(require 'emms-player-mpv)
(emms-standard) 
(emms-default-players)

;;-------------------------vterm
(add-to-list 'load-path "/home/n214/.emacs.d/elpa/emacs-libvterm")
(require 'vterm)

;;------------------------shell pop
(use-package shell-pop
  :config
  (defun shell-pop--set-exit-action ()
    (if (string= shell-pop-internal-mode "ansi-term")
        (add-hook 'eshell-exit-hook 'shell-pop--kill-and-delete-window nil t)
      (let ((process (get-buffer-process (current-buffer))))
        (when process
          (set-process-sentinel
           process
           (lambda (_proc change)
             (when (string-match-p "\\(?:finished\\|exited\\)" change)
               (if (one-window-p)
                   (switch-to-buffer shell-pop-last-buffer)
                 (kill-buffer-and-window)))))))))

  (custom-set-variables
   '(shell-pop-shell-type (quote ("vterm" "*vterm*" (lambda nil (vterm)))))
   '(shell-pop-term-shell "/usr/bin/zsh")
   '(shell-pop-window-position "right")))

(provide 'init-packages)
