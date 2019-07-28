;; Org mode

(with-eval-after-load 'org

  (setq org-agenda-files '(list "~/.emacs.d"
				"~/Dropbox/orgfiles"))
(setq org-src-fontify-natively t)

(setq org-capture-templates
      '(("t" "TODO" entry (file+headline "~/.emacs.d/gtd.org" "Work")
	 "* TODO  %?\n%u \n%T" :empty-lines 1)
	("g" "GCAL" entry (file  "~/Dropbox/orgfiles/gcal.org" )
             "* %?\n\n%^T\n\n:PROPERTIES:\n\n:END:\n\n" :prepend t))))

 (setq company-global-modes '(not org-mode))
 
(add-hook 'org-mode-hook '(lambda () (setq fill-column 130)))
(add-hook 'org-mode-hook 'turn-on-auto-fill)
(add-hook 'org-mode-hook 'org-bullets-mode)
;; C-c C-t TODO
;; C-c C-d Set deadline
;; C-c C-s Set schedule
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c w") 'org-pomodoro)
(global-set-key (kbd "C-c g p") (lambda () (interactive) (dired "~/Dropbox/MA1")))
(global-set-key (kbd "C-c g d") (lambda () (interactive) (dired "~/Downloads")))

;; Enable transient mark mode
(transient-mark-mode 1)
(setq org-list-description-max-indent 5)
(setq org-log-done t)
(setq org-log-done-with-time t)

;; r aka remember
(global-set-key (kbd "C-c r") 'org-capture)

(custom-set-variables
 '(company-idle-delay 0.1)
 '(company-minimum-prefix-length 1))

;;Org babel
(org-babel-do-load-languages
 'org-babel-load-languages '((python . t)))

;; org
(defvar org-ellipsis "⤵"
  "The indicates if an `org-mode' tree can be expanded") 

(defvar project-path
  (cond
   (linux? "~/Projects/")
   (:else nil))
  "Path to my projects directory")

(defvar org-dropbox-path
  (cond
   (linux?
    "~/Dropbox/org/")
   (:else nil))
  "Path to my org files inside dropbox")

;;----------------------------------------------gcal
(setq package-check-signature nil)

(use-package org-gcal
:ensure t
:config
(setq org-gcal-client-id "974105283419-o0ut7f3j25qk5da2p328eun38ggcvocp.apps.googleusercontent.com"
org-gcal-client-secret "9ATVy_noh00Ig9Q2yoDKSyyq"
org-gcal-file-alist '(("winnie0086@gmail.com" .  "~/Dropbox/orgfiles/gcal.org"))))

(add-hook 'org-agenda-mode-hook (lambda () (org-gcal-sync) ))
(add-hook 'org-capture-after-finalize-hook (lambda () (org-gcal-sync) ))

(setq org-agenda-custom-commands
'(("c" "Simple agenda view"
((agenda "")
(alltodo "")))))


(use-package calfw
:ensure t;TODO:
:config
(require 'calfw)
(require 'calfw-org)
(setq cfw:org-overwrite-default-keybinding t)
(require 'calfw-ical)

(defun mycalendar ()
(interactive)
(cfw:open-calendar-buffer
:contents-sources
(list
;; (cfw:org-create-source "Green")  ; orgmode source
(cfw:ical-create-source "gcal" "https://calendar.google.com/calendar/ical/winnie0086%40gmail.com/private-77b3a60ac5a8ba6409f1c514d5ad96e8/basic.ics" "IndianRed") ; google calendar ICS
)))

(setq cfw:org-overwrite-default-keybinding t))

(use-package calfw-gcal
:ensure t
:config
(require 'calfw-gcal))

(provide 'init-org)
