;; Org mode

(setq org-agenda-files '("~/org"))
;; C-c C-t TODO
;; C-c C-d Set deadline
;; C-c C-s Set schedule
(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-src-fontify-natively t)
(custom-set-variables
 '(company-idle-delay 0.1)
 '(company-minimum-prefix-length 1)

 )


(provide 'init-org)
