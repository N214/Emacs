;;-------------------------helm
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x b") #'helm-mini)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)

;;-------------------------smex

;;  (global-set-key (kbd "M-x") 'smex)
;;  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
;;
;;;;-------------------------ivy
;;(global-set-key (kbd "M-x") 'counsel-M-x)
;;(global-set-key (kbd "C-x C-f") 'counsel-find-file)
;;(global-set-key (kbd "C-c g") 'counsel-git)
;;(global-set-key (kbd "C-c p f") 'counsel-git)
;;(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
;;(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;;(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

;;---------------------------------init-file
(global-set-key (kbd "<f2>") 'open-init)
(global-set-key (kbd "<f3>") 'list-packages)

;; Indent all or select
(global-set-key (kbd "C-M-,") 'indent-region-or-buffer)

;;path auto complete
(global-set-key (kbd "TAB") 'hippie-expand)

(global-set-key "\C-x\ \C-r" 'recentf-open-files)
(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-h C-v") 'find-variable)
(global-set-key (kbd "C-h C-f") 'find-function-on-key)


;; enable this if you want `swiper' to use it
;; (setq search-default-mode #'char-fold-to-regexp)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "C-h f") 'counsel-describe-function)
(global-set-key (kbd "C-h v") 'counsel-describe-variable)


;;Dired mode bindings
(with-eval-after-load 'dired)
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)

;;Company C-n C-p movement
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

;;helm-ag
(global-set-key (kbd "C-c p s") 'helm-do-ag-project-root)

;;auto-yasnippets
(global-set-key (kbd "H-w") #'aya-create)
(global-set-key (kbd "H-y") #'aya-expand)

;;evil
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

;;code wrapped in eval-after-load to protect against the code executing too soon
(with-eval-after-load 'evil
  ;; use evil mode in the buffer created from calling `list-packages'.
  (add-to-list 'evil-buffer-regexps '("*Packages*" . normal))

  (with-eval-after-load 'package
    ;; movement keys j,k,l,h set up for free by defaulting to normal mode.
    ;; mark, unmark, install
    (evil-define-key 'normal package-menu-mode-map (kbd "m") #'package-menu-mark-install)
    (evil-define-key 'normal package-menu-mode-map (kbd "u") #'package-menu-mark-unmark)
    (evil-define-key 'normal package-menu-mode-map (kbd "x") #'package-menu-execute)))

;;Spotify
(global-set-key (kbd "C-c s s") 'helm-spotify-plus)
(global-set-key (kbd "C-c s f") 'helm-spotify-plus-next)
(global-set-key (kbd "C-c s b") 'helm-spotify-plus-previous)
(global-set-key (kbd "C-c s p") 'helm-spotify-plus-toggle-play-pause)

;;window resize
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'enlarge-window)
(global-set-key (kbd "S-C-<up>") 'shrink-window)

;;evil tabs

(global-set-key (kbd "C-c n") 'elscreen-create)
(global-set-key (kbd "C-c l") 'elscreen-select-and-goto)

(provide 'init-keybindings)
