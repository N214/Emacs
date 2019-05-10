;;-------------------------------
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-splash-screen t)
(setq org-src-fontify-natively t)
(global-hl-line-mode t)

;;-------------------------------

;;(load-theme 'monokai t)
(set-default-font "Monospace-9")
(setq default-frame-alist '((font . "Monospace-9")))

;;-------------------------------
(setq-default cursor-type 'bar) 
;;(require 'org')
;; set color font for org mode code

;;------------------------------------------fullscreen startup
(setq initial-frame-alist (quote ((fullscreen, maximized))))

(provide 'init-ui)
