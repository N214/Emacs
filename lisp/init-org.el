;; Org mode

(with-eval-after-load 'org

(setq org-agenda-files '("~/.emacs.d"))
(setq org-src-fontify-natively t)
(setq org-capture-templates
      '(("t" "TODO" entry (file+headline "~/.emacs.d/gtd.org" "Work")
	 "* TODO [#B] %?\n %i\n"
	 :empty-lines 1)))
  )
;; C-c C-t TODO
;; C-c C-d Set deadline
;; C-c C-s Set schedule
(global-set-key (kbd "C-c a") 'org-agenda)

;; Enable transient mark mode
(transient-mark-mode 1)
(setq org-list-description-max-indent 5)


;; r aka remember
(global-set-key (kbd "C-c r") 'org-capture)

(custom-set-variables
 '(company-idle-delay 0.1)
 '(company-minimum-prefix-length 1)

 )

;; org calendar



(provide 'init-org)
