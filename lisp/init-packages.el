;;----------Package Manager---------------------
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)

 ; (setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
 ;                        ("melpa" . "http://elpa.emacs-china.org/melpa/")))
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

;;---------------Which-key
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;;---------------Smartparens

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode 1)))

;;-------------spotify-helm
(use-package helm-spotify-plus
  :ensure t
  :config)


;;---------popwin mode
(require 'popwin)
(popwin-mode t)

;;---------relative linum
;;(linum-relative-in-helm-p nil)
(global-linum-mode nil)
(linum-relative-toggle)

;;---------evil-mode

(use-package evil-leader
  :ensure t
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader ",")        
  (evil-leader/set-key
    "f" 'ranger
    "s" 'shell-pop
    "q" 'kill-buffer-and-window
    "w" 'save-buffer
    "r" 'transpose-frame
    "R" 'load-init
    "b" 'mode-line-other-buffer
    "k" 'kill-buffer
    "m" 'helm-mini
    "e" 'iedit-mode
    "n" 'narrow-or-widen-dwim
    "a" 'org-agenda
    "g"  'magit-status
    "''" 'org-edit-src-exit
    "TAB" 'elscreen-next
    ))


(use-package evil
  :ensure t
    :bind
  (:map evil-motion-state-map
        ("C-u" . evil-scroll-up))
  :init
    (setq evil-want-C-u-scroll t
        evil-want-C-i-jump t
        evil-want-Y-yank-to-eol t)
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-maybe-remove-spaces t)
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (evil-escape-mode 1)
  (evil-set-initial-state 'pdf-view-mode 'normal)
  (setq evil-split-window-below t
        evil-vsplit-window-right t)
  (setq-default evil-symbol-word-search t)
  (custom-set-variables '(evil-search-module (quote evil-search)))
  (evil-ex-define-cmd "re[load]" 'load-init) ; Custom reload command
  (evil-ex-define-cmd "Q" 'save-buffers-kill-terminal) ; For typos
  (add-to-list 'evil-emacs-state-modes 'vterm-mode)
  (general-define-key
   :states 'visual
   "<" (lambda ()
         (interactive)
         (evil-shift-left (region-beginning) (region-end))
         (evil-normal-state)
         (evil-visual-restore))
   ">" (lambda ()
         (interactive)
         (evil-shift-right (region-beginning) (region-end))
         (evil-normal-state)
         (evil-visual-restore)))
  (general-define-key
   :states 'normal
   "C-z"  'controlz
   "C-l"  'evil-ex-nohighlight)
  )

(use-package evil-lion
  :ensure t
  :config
  (evil-lion-mode))

;(use-package evil-collection
;  :after evil
;  :ensure t
;  :init
;  :config
;  (evil-collection-init))

(setq-default evil-escape-key-sequence "jk")

;;(evil-leader/set-ket "d" 'kill-buffer-and-window)

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
(setq helm-ff-toggle-auto-update t)
(setq helm-ff-auto-update-initial-value t)
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
(use-package yasnippet
  :ensure t
  :config
  (yas-reload-all)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"))
  (add-hook 'prog-mode-hook #'yas-minor-mode))

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

;;-----------------------jedi-mode
(use-package jedi
:ensure t
:init
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'jedi:ac-setup))

;;-----------------------python-mode

(use-package anaconda-mode
    :ensure t
    :bind ("C-c C-d" . anaconda-mode-show-doc)
    :config
    (setq python-shell-interpreter "ipython"))


(use-package company-anaconda
    :ensure t
    :after (python-mode)
    :init
    (eval-after-load "company"
      '(add-to-list 'company-backends '(company-anaconda :with company-capf))))

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :init
  (add-hook 'python-mode-hook 'flycheck-mode)
  :config
  (add-hook 'python-mode-hook
	    (defun hooks()
	      (smartparens-mode 1)
              (rainbow-delimiters-mode 1)
	      (company-mode 1)
              (yas-minor-mode 1)
	      (highlight-indent-guides-mode 1)
              (anaconda-mode 1)))

  (require 'flycheck-pyflakes)
  (add-to-list 'flycheck-disabled-checkers 'python-flake8)
  (add-to-list 'flycheck-disabled-checkers 'python-pylint)

  (setq warning-suppress-types '((python)
                                 (emacs))))

(add-hook 'python-mode-hook
          (lambda ()
            (pretty-symbol-push-default)
            (push '("def"    . ?ƒ) prettify-symbols-alist)
            (push '("sum"    . ?Σ) prettify-symbols-alist)
            (push '("**2"    . ?²) prettify-symbols-alist)
            (push '("**3"    . ?³) prettify-symbols-alist)
            (push '("None"   . ?∅) prettify-symbols-alist)
            (push '("in"     . ?∈) prettify-symbols-alist)
            (push '("not in" . ?∉) prettify-symbols-alist)
            (push '("return" . ?➡) prettify-symbols-alist)
            (prettify-symbols-mode t)))


(eval-after-load "company"
 '(add-to-list 'company-backends 'company-anaconda))


(use-package highlight-indent-guides
    :ensure t
    :after (python-mode)
    :config
    (setq highlight-indent-guides-method 'character))

(use-package company-jedi
:ensure t
:config
(add-hook 'python-mode-hook 'jedi:setup))

(defun my/python-mode-hook ()
(add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)

;;------------------elpy for python completion
;;(use-package elpy
;;  :ensure t
;;  :init
;;  (elpy-enable)
;;  (exec-path-from-shell-copy-env "PATH")
;;  (setq python-shell-interpreter "ipython"
;;      python-shell-interpreter-args "-i --simple-prompt")
;;  (with-eval-after-load 'python
;;  (remove-hook 'python-mode-hook #'python-setup-shell)))

;;------------------flycheck
;;(when (require 'flycheck nil t)
 ;; (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  ;;(add-hook 'elpy-mode-hook 'flycheck-mode))

;;-------------------pip8
;;(require 'py-autopep8)
;;(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)


;;---------------------ispell hunderspell

(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
(autoload 'flyspell-delay-command "flyspell" "Delay on command." t)
(autoload 'tex-mode-flyspell-verify "flyspell" "" t) 

(dolist (hook '(text-mode-hook))
    (add-hook hook (lambda () (flyspell-mode 1))))

(dolist (hook '(org-mode-hook))
    (add-hook hook (lambda () (flyspell-mode -1))))

(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1))))


(defun flymake-get-tex-args (file-name)
    (list "chktex" (list "-q" "-v0" file-name)))
(require 'flyspell-lazy)
(flyspell-lazy-mode 1)

;;---------------------symon
  (require 'symon)
  (symon-mode t)


;;--------------------evil-tabs
(global-evil-tabs-mode t)
(elscreen-toggle-display-tab)

;;-----------------------emms player
;;(require 'emms-setup)
;;(require 'emms-player-mpv)
;;(emms-standard) 
;;(emms-default-players)

(use-package emms
    :ensure t
    :config
    (emms-all)
    (emms-default-players)
    (setq emms-player-list '(emms-player-mpv))
    (setq emms-source-file-default-directory "~/Music/")
    (setq emms-playlist-buffer-name "*Music*")
    (setq emms-info-asynchronously t)
    (require 'emms-mode-line)
    (emms-mode-line 1)
    (require 'emms-playing-time)
    (emms-playing-time 1))
;;-------------------------vterm
(add-to-list 'load-path "/home/n214/.emacs.d/elpa/emacs-libvterm")
(add-to-list 'load-path "/home/n214/.emacs.d/elpa/emacs-libvterm-tog")

(require 'vterm-toggle)
(use-package tramp-term
  :ensure t)

(use-package vterm
  :config
  (add-hook 'vterm-mode-hook
            (lambda ()
              (setq global-hl-line-mode nil))))


(setq vterm-toggle-fullscreen-p nil)
(setq display-buffer-alist
      '(
        ("vterm.*"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (reusable-frames . visible)
         (side . bottom)
         (window-height . 0.3)
         )))

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

;;------------------------Auctex

(use-package tex
  :defer t
  :ensure auctex
  :config
  (setq TeX-auto-save t)
  (add-hook 'latex-mode-hook
            (lambda ()
              (rainbow-delimiters-mode)
              (company-mode)
              (smartparens-mode)
              (flyspell-mode)
              (turn-on-reftex)
              (setq reftex-plug-into-auctex t)
              (reftex-isearch-minor-mode)
              (setq tex-pdf-mode t)
              (setq tex-source-correlate-method 'synctex)
              (setq tex-source-correlate-start-server t)))
  (add-hook 'TeX-after-TeX-LaTeX-command-finished-hook
	    #'TeX-revert-document-buffer)
  (setq TeX-view-program-selection '((output-pdf "pdf-tools"))
	TeX-source-correlate-start-server t)
  (setq TeX-view-program-list '(("pdf-tools" "TeX-pdf-tools-sync-view"))))


;;----------------------reftex
(use-package reftex
  :ensure t
  :defer t
  :config
  (setq reftex-cite-prompt-optional-args t)); Prompt for empty optional arguments in cite


;;----------------------ivy bibtex
(use-package ivy-bibtex
  :ensure t
  :bind ("C-c b b" . ivy-bibtex)
  :config
  (setq bibtex-completion-bibliography 
        '("/home/n214/Dropbox/MA1/Thesis/Papers/biblio.bib")
        bibtex-completion-library-path
        '("/home/n214/Dropbox/MA1/Thesis/Papers/"))

  ;; using bibtex path reference to pdf file
  (setq bibtex-completion-pdf-field "File")
  (setq ivy-bibtex-default-action 'ivy-bibtex-insert-citation))

(setq bibtex-completion-pdf-open-function
      (lambda (fpath)
	(call-process "zathura" nil 0 nil fpath)))

(use-package magit ; TODO key bindings and such
  :ensure t)

;;-----------------------Ace window
(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    ))

;;-----------------------ox-reveal slides
(use-package ox-reveal
  :ensure ox-reveal)
(setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/")
(setq org-reveal-mathjax t)

;;--------------------------------------------------------rotate windows
(use-package transpose-frame
  :ensure t
  :init) 

;;--------------------------------------------------------
(use-package column-marker
  :ensure nil
  :config
  (add-hook 'prog-mode-hook (lambda () (interactive) (column-marker-1 81)))
  (custom-set-faces
   '(column-marker-1 ((t (:background "dim gray"))))))

;;--------------------------------------------------------org mode bullets
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package ag
  :ensure t
  :bind (:map ag-mode-map
	      ("Q" . ag-kill-buffers-and-window)))

(use-package wgrep
  :ensure t)

(use-package wgrep-ag
  :ensure t)
;;--------------------------------------------------------org alert

(use-package org-alert
  :config)

(provide 'init-packages)
