;;Default setting for a better Emacs
(use-package company
:ensure t
:config
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 3)
(global-company-mode t))

(menu-bar-mode -1)
(electric-indent-mode)
(global-auto-revert-mode t)
(delete-selection-mode t)
(setq x-select-enable-clipboard t)

(require 'recentf) ;;We have a file named recentf and we need this file to enalble recentf
(recentf-mode 1)
(setq recentf-max-menu-items 25)

;; Disable scroll bar
(defun my/disable-scroll-bars (frame)
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))
(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)



;; ----------------------------
(define-advice show-paren-function (:around (fn) fix-show-paren-function)
    ;;Highlight enclosing parens
(cond ((looking-at-p "\\s(") (funcall fn))
      (t (save-excursion
	   (ignore-errors (backward-up-list))
	   (funcall fn)))))

(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)

(setq make-backup-files nil)
(setq auto-save-default nil)
(windmove-default-keybindings)


;;Use package config
(eval-when-compile
  (require 'use-package))

(require 'diminish)
(require 'bind-key)

;; Package
;; Impossible to load theme on other file




;;--------------------------------------Snippets

(abbrev-mode t)
(define-abbrev-table 'global-abbrev-table '(
					    ;; Signature
					    ("Nico" "Yu-Wei Nicolas Tang")

					    ;; Emails
					    ("mu" "yuwetang@ulb.ac.be")
					    ("mg" "nico9156@gmail.com")
					    ("mw" "winnie0086@gmail.com")
					    ))

;;----------------------------------one key indent function
(defun indent-buffer()
  ;;indent the current buffer
  (interactive)
  (indent-region (point-min) (point-max)))
(defun indent-region-or-buffer()
  ;;indent region if selected otherwise indent all buffer
  (interactive)
  (save-excursion
    (if (region-active-p)
	(progn
	  (indent-region (region-beginning) (region-end))
	  (message "Indented selected region"))
      (progn
	(indent-buffer)
	(message "Buffer indented")))))


;;-------------------------------------hippie expend on steroïd
(setq hippie-expand-try-functions-list '(try-expand-dabbrev
					 try-expand-dabbrev-all-buffers
					 try-expand-dabbrev-from-kill
					 try-complete-file-name-partially
					 try-complete-file-name
					 try-expand-all-abbrevs
					 try-expand-list
					 try-expand-line
					 try-complete-lisp-symbol-partially
					 try-complete-lisp-symbol))

;;--------------------------------------dired mode conf
;; C-x d: enter dired mode
;; +: create new directory
;; C-x C-f: crete new file
;; g: refresh dired buffer
;; C: copy file
;; d: mark file for delete
;; x: execte marked files
;; D: delete and confirm
;; R: rename file
;; c: compress file

(fset 'yes-or-no-p 'y-or-n-p)
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)

(put 'dired-find-alternate-file 'disabled nil)

(defalias 'list-buffers 'ibuffer-list-buffers)
;; with this line, C-x C-j open the current dir in dired mode
(require 'dired-x)

;;easy copy between vertical split
(setq dired-dwim-target t)

;;----------------------------------------Remove dos end of line
(defun remove-dos-eol ()
  ;;remove dos eolns CR LF with Unix eolns CR")
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t) (replace-match "")))

;;---------------------------------------------------------------Rmarkdown
;; spa/rmd-render
;; Global history list allows Emacs to "remember" the last
;; render commands and propose as suggestions in the minibuffer.
(defvar rmd-render-history nil "History list for spa/rmd-render.")
(defun spa/rmd-render (arg)
  "Render the current Rmd file to PDF output.
   With a prefix arg, edit the R command in the minibuffer"
  (interactive "P")
  ;; Build the default R render command
  (setq rcmd (concat "rmarkdown::render('" buffer-file-name "',"
                 "output_dir = './',"
                 "output_format = 'pdf_document')"))
  ;; Check for prefix argument
  (if arg
      (progn
    ;; Use last command as the default (if non-nil)
    (setq prev-history (car rmd-render-history))
    (if prev-history
        (setq rcmd prev-history)
      nil)
    ;; Allow the user to modify rcmd
    (setq rcmd
          (read-from-minibuffer "Run: " rcmd nil nil 'rmd-render-history))
    )
    ;; With no prefix arg, add default rcmd to history
    (setq rmd-render-history (add-to-history 'rmd-render-history rcmd)))
  ;; Build and evaluate the shell command
  (setq command (concat "echo \"" rcmd "\" | R --vanilla"))
  (compile command))
;;(define-key polymode-minor-mode (kbd "C-c r")  'spa/rmd-render)

;;--------------------------------------------------Hide compilation
; from enberg on #emacs
(setq compilation-finish-function
  (lambda (buf str)
    (if (null (string-match ".*exited abnormally.*" str))
        ;;no errors, make the compilation window go away in a few seconds
        (progn
          (run-at-time
           "2 sec" nil 'delete-windows-on
           (get-buffer-create "*compilation*"))
          (message "No Compilation Errors!")))))

;;--------------------------------------------------defun

(defun load-init ()
    "Reload init file"
    (interactive)
    (load-file "~/.emacs.d/n214.el"))

(defun call-and-update-ex (fun)
  "Calls the function and updates `evil-ex-history' with the result"
  (interactive)
  (setq evil-ex-history (cons (format "e %s" (funcall fun)) evil-ex-history)))

(defun controlz ()
  (interactive)
  (when (eq (display-graphic-p) nil)
    (suspend-frame)))

;;
(defun move-buffer-file (dir)
 "Moves both current buffer and file it's visiting to DIR." (interactive "DNew directory: ")
 (let* ((name (buffer-name))
	 (filename (buffer-file-name))
	 (dir
	 (if (string-match dir "\\(?:/\\|\\\\)$")
	 (substring dir 0 -1) dir))
	 (newname (concat dir "/" name)))

 (if (not filename)
	(message "Buffer '%s' is not visiting a file!" name)
 (progn 	(copy-file filename newname 1) 	(delete-file filename) 	(set-visited-file-name newname) 	(set-buffer-modified-p nil) 	t)))) 

(defvar linux? (eq system-type 'gnu/linux)
  "Are we on linux?")

;;----------------------------------------------------------vim scrolloff
(setq scroll-margin 10
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

;;---------------------------------------------------------sshx
(customize-set-variable 'tramp-verbose 6 "Enable remote command traces")
(customize-set-variable 'tramp-default-method "sshx")

(defun vps()
    (interactive)
    (let ((default-directory "/sshx:n214@vps:"))
      ()))




;;(add-hook '(vterm-mode-hook
    ;;(lambda () (setq global-hl-line-mode -1)))

(provide 'init-better-default)

