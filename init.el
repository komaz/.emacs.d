(require 'package)

(package-initialize)

;; ("melpa" . "http://melpa.milkbox.net/packages/")
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("melpa-stable" . "http://stable.melpa.org/packages/")))
(require 'use-package)
(global-unset-key (kbd "s-z"))
(global-unset-key (kbd "s-m"))
(global-unset-key (kbd "M-\\"))

(use-package magit 
  :bind (("M-g s" . magit-status)
	 ("M-g b" . magit-blame-mode)
	 ("s-m m" . magit-status))
  :init (setq
         magit-last-seen-setup-instructions "1.4.0"
         magit-emacsclient-executable "/usr/local/bin/emacsclient")
  :ensure t)

(use-package window-number
  :init (progn
	  (window-number-mode 1)
	  (window-number-meta-mode 1))
  :ensure t)

(if (display-graphic-p)
    (use-package unicode-fonts
      :init (unicode-fonts-setup)
      :ensure t))

(use-package quail
  :init (progn 
	  (quail-define-package
	   "cyrillic-dvorak" "Cyrillic" "ЙЦУК" nil
	   "ЙЦУКЕН keyboard layout widely used in Russia (ISO 8859-5 encoding)
  in assuming that your default keyboard layout is dvorak"
	   nil t t t t nil nil nil nil nil t)
	  (quail-define-rules ("§" ?ё) ("1" ?1) ("2" ?2) ("3" ?3) ("4" ?4) ("5" ?5) ("6" ?6) ("7" ?7) ("8" ?8) ("9" ?9) ("0" ?0) ("[" ?_) ("]" ?=) ("`" ?ё) 
			      ("'" ?Й) ("," ?ц) ("." ?у) ("p" ?к) ("y" ?е) ("f" ?н) ("g" ?г) ("c" ?ш) ("r" ?щ) ("l" ?з) ("/" ?х) ("=" ?ъ) 
			      ("a" ?ф) ("o" ?ы) ("e" ?в) ("u" ?а) ("i" ?п) ("d" ?р) ("h" ?о) ("t" ?л) ("n" ?д) ("s" ?ж) ("-" ?э) ("\\" ?\\) 
			      (";" ?я) ("q" ?ч) ("j" ?с) ("k" ?м) ("x" ?и) ("b" ?т) ("m" ?ь) ("w" ?б) ("v" ?ю) ("z" ?.) 
			      ("±" ?Ё) ("!" ?!) ("@" ?\") ("#" ?') ("$" ?\;) ("%" ?%) ("^" ?:) ("&" ??) ("*" ?*) ("(" ?() (")" ?)) ("{" ?-) ("}" ?+) ("~" ?Ё) 
			      ("\"" ?й) ("<" ?Ц) (">" ?У) ("P" ?К) ("Y" ?Е) ("F" ?Н) ("G" ?Г) ("C" ?Ш) ("R" ?Щ) ("L" ?З) ("?" ?Х) ("+" ?Ъ) 
			      ("A" ?Ф) ("O" ?Ы) ("E" ?В) ("U" ?А) ("I" ?П) ("D" ?Р) ("H" ?О) ("T" ?Л) ("N" ?Д) ("S" ?Ж) ("_" ?Э) ("|" ?/) 
			      (":" ?Я) ("Q" ?Ч) ("J" ?С) ("K" ?М) ("X" ?И) ("B" ?Т) ("M" ?Ь) ("W" ?Б) ("V" ?Ю) ("Z" ?,))
	  (setq default-input-method "cyrillic-dvorak")))

(use-package multiple-cursors
  :bind (("C-c a" . mc/edit-lines)
	 ("C-c m" . mc/mark-all-like-this))
  :ensure t)

(use-package htmlize :ensure t)

(use-package org
  :init (progn 
	  (add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
	  (defun insert-jira-link (id)
	    "Insert org-mode link to jira"
	    (interactive "sKEY: ")
	    (set 'id (upcase id))
	    (insert (format "[[http://jira4.xored.com/browse/%s][%s]]" id id)))

	  (defun insert-bugzilla-link (id)
	    "Insert org-mode link to bugzilla"
	    (interactive "sKEY: ")
	    (set 'id (upcase id))
	    (insert (format "[[https://bugs.eclipse.org/bugs/show_bug.cgi?id=%s][#%s]]" id id)))

	  (defun insert-ecl-link (id)
	    "Insert org-mode link to jira"
	    (interactive "sCOMMAND: ")
	    (insert (format "[[http://download.xored.com/q7/docs/ecl-api/latest#%s][%s]]" id id)))

	  (defun insert-support-link (id)
	    "Insert org-mode link to helpdesk"
	    (interactive "N")
	    (insert (format "[[http://support.xored.com/helpdesk/tickets/%d][#%d]]" id id)))

	  (defun new-mail (topic)
	    "Start typing org-mode mail now"
	    (interactive "sTOPIC: ")
	    (if (= (length topic) 0)
		(set 'topic "no-subj"))
	    (let ((tmpfile (concat
			    "~/dropbox/notes/mails/"
			    (format-time-string "%y-%m-%d %H:%M ")
			    topic ".org")))
	      (copy-file "~/.emacs.d/templates/mail.org"
			 tmpfile)
	      (find-file tmpfile)
	      (next-line 5)))
	  (setq org-tags-column 0
		org-export-allow-BIND t
		org-export-allow-bind-keywords t
		org-confirm-babel-evaluate nil
		org-src-lang-modes '(("ecl" . fundamental)
				     ("ocaml" . tuareg)
				     ("elisp" . emacs-lisp)
				     ("ditaa" . artist)
				     ("asymptote" . asy)
				     ("dot" . graphviz-dot)
				     ("sqlite" . sql)
				     ("calc" . fundamental)
				     ("C" . c)
				     ("cpp" . c++)
				     ("screen" . shell-script))
                org-log-done 'time
		org-agenda-files (list "~/dropbox/notes/gtd")
		org-default-notes-file "~/dropbox/notes/gtd/inbox.org"
		org-refile-targets  '((nil :maxlevel . 9)
				    (org-agenda-files :maxlevel . 9)))
	  (org-babel-do-load-languages
	   'org-babel-load-languages
	   '(   (sh . t)
		(python . t)
		(R . t)
		(ruby . t)
		(ditaa . t)
		(dot . t)
		(octave . t)
		(sqlite . t)
		(perl . t)
		(ledger . t) ))
	  (defun sacha/org-html-checkbox (checkbox)
	    "Format CHECKBOX into HTML."
	    (case checkbox (on "<span class=\"check\">&#x2713;</span>") ; checkbox (checked)
		  (off "<span class=\"checkbox\">&#x2717;</span>")
		  (trans "<code>[-]</code>")
		  (t "")))
	  (defadvice org-html-checkbox (around sacha activate)
	    (setq ad-return-value (sacha/org-html-checkbox (ad-get-arg 0)))))
  :config (progn
	    (require 'ob)
	    (require 'ob-eval)

	    (defvar org-babel-default-header-args:ecl
	      '((:results . "html") (:exports . "results"))
	      "Default arguments to use when evaluating a pygment source block.")

	    (defun org-babel-execute:ecl (body params)
	      "Execute a block of Dot code with org-babel.
This function is called by `org-babel-execute-src-block'."
	      (let* ((result-params (split-string (or (cdr (assoc :results params)) "")))
		     (out-file (cdr (assoc :file params)))
		     (cmdline (cdr (assoc :cmdline params)))
		     (in-file (org-babel-temp-file "ecl-"))
		     (cmd (concat org-ecl-path
				  " " cmdline
				  " " (org-babel-process-file-name in-file)
				  )))
		(unless (file-exists-p org-ecl-path)
		  (error "Could not find pygment at %s" org-ecl-path))
		(message (concat "Running Pygment: " cmd))
		(with-temp-file in-file (insert body))
		(org-babel-eval cmd "")
		))

	    (defun org-babel-prep-session:ecl (session params)
	      "Return an error because ECL does not support sessions."
	      (error "ECL does not support sessions"))

	    (setq org-ecl-path "/Users/ivaninozemtsev/dropbox/solutions/prepare.py")
	    (setq org-babel-load-languages (append org-babel-load-languages '((ecl . t)))))
  :bind (("C-c s" . insert-support-link)
	 ("C-c j" . insert-jira-link)
	 ("C-c e" . insert-ecl-link)
	 ("C-c b" . insert-bugzilla-link)
	 ("s-t" . org-todo-list)
	 ("s-s" . org-schedule)
	 ("s-a" . org-agenda)
	 ("s-c" . org-capture))
  :ensure t)

(use-package load-dir
  :init (setq load-dirs t)
  :ensure t)

(if (display-graphic-p)
    (use-package graphviz-dot-mode
      :init (progn
	      (setq graphviz-dot-view-command "dot -Tpng %s | open -f -a Preview.app")

	      (defun my-dot-preview () "" (interactive)
		(progn
		  (save-buffer)
		  (compile compile-command)
		  (sleep-for 1)
		  (graphviz-dot-preview)))
	      (add-hook 'graphviz-dot-mode-hook
                        (lambda () (add-hook 'after-save-hook 'my-dot-preview nil t))))
      :bind (("s-p" . my-dot-preview))
      :ensure t))




(use-package s :ensure t)


(use-package ledger-mode
  :bind (("C-c t" . insert-ledger-timestamp))
  :init (progn
	  (defun get-line (num)
	    (let ((actual (+ num 1)))
	      (buffer-substring-no-properties
	       (line-beginning-position actual)
	       (line-end-position actual))))
	  (defun insert-ledger-timestamp () "Add YYYY/MM/DD"
		 (interactive)
		 (let ((curr-line (s-trim (get-line 0))) (prev-line (s-trim (get-line -1))))
		   (if (> (length curr-line) 0)
		       (insert "\n\n")
		     (if (> (length prev-line) 0)
			 (insert "\n")
		       (let ((len (length (get-line 0))))
			 (delete-backward-char len))))
		   (insert (format-time-string "%Y/%m/%d "))))	  )
  :ensure t)

(use-package direx
  :init (setq direx:closed-icon " ▶ "
	      direx:open-icon " ▼ ")
  :config (progn
	    (defun mark-for-direx (buf) "Work in progress, dedicated windows for files opened in direx" (interactive "b")
		   (if (not (boundp 'direx-windows))
		       (setq direx-windows ()))
		   (add-to-list 'direx-windows (cons (get-buffer buf) (selected-window))))

	    (defun my-direx-open () "" (interactive)
		   (if (not (boundp 'direx-windows))
		       (setq direx-windows ()))

		   (setq item (direx:item-at-point!))
		   (if (direx:item-leaf-p item)
		       (let ((filename (direx:file-full-name (direx:item-tree item)))
			     (wnd (cdr (assoc (current-buffer) direx-windows))))
			 (let ((filebuf (find-file-noselect filename)))
			   (if wnd
			       (set-window-buffer wnd filebuf)
			     (find-file-other-window filename))))))
	    
	    (bind-key (kbd "RET") 'my-direx-open direx:direx-mode-map)
	    (bind-key (kbd "C-o") 'my-direx-open direx:direx-mode-map)
	    )
  :bind ("C-x j" . direx:jump-to-directory)
  :ensure t)

(use-package smartparens
  :config (progn
	    (require 'smartparens-config)
	    (setq sp-base-key-bindings 'paredit
		  sp-autoskip-closing-pair 'always)
	    (sp-use-paredit-bindings)
	    (show-smartparens-global-mode +1)
	    (smartparens-global-mode +1)
	    (global-set-key (kbd "M-(") (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "(")))
	    (global-set-key (kbd "M-[") (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "[")))
	    (global-set-key (kbd "M-\"") (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "\""))))
  :ensure t)

(use-package dedicated :ensure t)

(use-package swiper :ensure t
             :config (progn (ivy-mode 1)
                            (setq ivy-use-virtual-buffers t)
                            (setq ido-use-faces nil)
                            (global-set-key "\C-s" 'swiper)
                            (global-set-key "\C-r" 'swiper)
                            (global-set-key (kbd "C-c C-r") 'ivy-resume)
                            (global-set-key [f6] 'ivy-resume)))

(use-package find-file-in-project
  :bind ("s-f" . find-file-in-project)
  :ensure t)

(use-package jump-char
  :bind (("M-m" . jump-char-forward) 
	 ("M-S-m" . jump-char-backward))
  :ensure t)

(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
(setq exec-path (append exec-path '("/usr/local/bin")))
(setq blink-matching-paren nil)
;; Appearance
(tool-bar-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode -1)

(if (display-graphic-p)
    (scroll-bar-mode -1))
(setq confirm-kill-emacs 'y-or-n-p)
(setq column-number-mode t)
(setq-default indent-tabs-mode nil)
(if (display-graphic-p)
    (server-start))


(if (display-graphic-p)
    (use-package 
      edit-server
      :init (edit-server-start)
      :ensure t))

(use-package scala-mode2 :ensure t)

'(use-package ensime 
  :init (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
  :ensure t)

(use-package ntcmd
  :ensure t)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)


(defvar pre-ediff-window-configuration nil
  "window configuration to use")
(defvar new-ediff-frame-to-use nil
  "new frame for ediff to use")
(defun save-my-window-configuration ()
  (interactive)
  (setq pre-ediff-window-configuration (current-window-configuration))
  (select-frame-set-input-focus (setq
				 new-ediff-frame-to-use (new-frame))))

(add-hook 'ediff-before-setup-hook 'save-my-window-configuration)
(defun restore-my-window-configuration ()
  (interactive)
  (when (framep new-ediff-frame-to-use)
    (delete-frame new-ediff-frame-to-use)
    (setq new-ediff-frame-to-use nil))
  (when (window-configuration-p pre-ediff-window-configuration
				(set-window-configuration pre-ediff-window-configuration))))
(add-hook 'ediff-after-quit-hook-internal 'restore-my-window-configuration)


(setq highlight-nonselected-windows t)
(add-hook 'prog-mode-hook 'subword-mode)

(if (display-graphic-p)
    (progn
      (load-theme 'tango-dark t)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (select-frame frame)
                  (load-theme 'tango-dark t)
                  (set-face-attribute 'default nil :background "#212526")))
      (set-face-attribute 'default nil :background "#212526")
      (set-face-attribute 'default nil :font "Anonymous Pro-12")))





(if (display-graphic-p)
    (use-package deft
      :init (setq deft-extension "org"
		  deft-directory "~/dropbox/notes/mails"
		  deft-text-mode 'org-mode)
      :config (progn
		(defun deft-parse-title (file contents)
		  "Get title from MY notes"
		  (when-let
		   (result
		    (catch 'return
		      (when-let
		       (org-title (progn
				    (string-match "^#\\+TITLE:\s*\\([^\s].+\\)+$" contents)
				    (match-string 1 contents)))
		       (throw 'return org-title))
		      (when-let
		       (begin (string-match "^[^#].+$" contents))
		       (throw 'return (substring contents begin (match-end 0))))))
		   (funcall deft-parse-title-function result))))
      :ensure t))

(use-package wgrep
  :ensure t)
;; make zap-to-char act like zap-up-to-char
(defadvice zap-to-char (after my-zap-to-char-advice (arg char) activate)
  "Kill up to the ARG'th occurence of CHAR, and leave CHAR.
  The CHAR is replaced and the point is put before CHAR."
  (insert char)
  (forward-char -1))

(global-set-key (kbd "C-|")
		(lambda (&optional arg) (interactive "P")
		  (let ((windows (window-list)))
		    (when (= 2 (length windows))
		      (let ((first-window (car windows))
			    (second-buffer (window-buffer (nth 1 windows))))
			(delete-other-windows first-window)
			(set-window-buffer (split-window-right) second-buffer))))))

'(global-set-key (kbd "C-x 5")
		(lambda (&optional arg) (interactive "P")
		  (split-window-right (/ (window-total-width) 3))))

(defun gtd () "" (interactive) (find-file "~/dropbox/notes/gtd/work.org"))

(defun fit () "" (interactive) (find-file "~/dropbox/notes/fit.org"))

(defun ldg () "" (interactive) (find-file "~/dropbox/appdata/ledger/ledger.txt"))

(defun kill-back () "" (interactive) (kill-sexp -1))
(global-set-key [C-M-backspace] 'kill-back)

(use-package haskell-mode
  :init (progn
	  (define-key haskell-mode-map (kbd "C-x C-d") nil)
	  (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
	  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-file)
	  (define-key haskell-mode-map (kbd "C-c C-b") 'haskell-interactive-switch)
	  (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
	  (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
	  (define-key haskell-mode-map (kbd "C-c M-.") nil)
	  (define-key haskell-mode-map (kbd "C-c C-d") nil)
	  (setq haskell-process-path-ghci "/Users/ivaninozemtsev/ghc/bin/ghci"))
  :ensure t)
(use-package php-mode :ensure t)

(global-set-key (kbd "s-/") 'comment-dwim)

(use-package nginx-mode :ensure t)

(use-package markdown-mode :ensure t)

(use-package lua-mode :ensure t)

(setq large-file-warning-threshold 150000000)

(use-package twig-mode :ensure t)

(use-package cider
  :config (progn
          (setq cider-lein-command "/Users/ivaninozemtsev/bin/lein")
          (local-set-key (kbd "M-/") 'company-complete))
  :ensure t)


(use-package hydra :ensure t
  :init (progn
	  (defhydra hydra-zoom (global-map "s-z")
	    "zoom"
	    ("g" text-scale-increase "in")
	    ("l" text-scale-decrease "out"))))


(use-package company
  :ensure t
  :init (progn
          (add-hook 'cider-repl-mode-hook
                    (lambda ()
                      (company-mode)
                      (company-quickhelp-mode 1)
                      (local-set-key (kbd "M-/") 'company-complete)))
          (add-hook 'cider-mode-hook (lambda ()
                      (company-mode)
                      (company-quickhelp-mode 1)
                      (local-set-key (kbd "M-/") 'company-complete)))))

(use-package easy-kill
  :ensure t
  :config (progn
            (global-set-key [remap kill-ring-save] 'easy-kill)))

(use-package image+ :ensure t
  :init (eval-after-load 'image '(require 'image+))
  :config (defhydra imagex-sticky-binding (global-map "C-x C-l")
            "Manipulating Image"
            ("+" imagex-sticky-zoom-in "zoom in")
            ("-" imagex-sticky-zoom-out "zoom out")
            ("M" imagex-sticky-maximize "maximize")
            ("O" imagex-sticky-restore-original "restore original")
            ("S" imagex-sticky-save-image "save file")
            ("r" imagex-sticky-rotate-right "rotate right")
            ("l" imagex-sticky-rotate-left "rotate left")))

(global-set-key (kbd "C-. C-f") (lambda (&optional arg) (interactive "P") (insert "→")))
(global-set-key (kbd "C-. C--") (lambda (&optional arg) (interactive "P") (insert "–")))


(define-key key-translation-map [?\C-h] [?\C-?])
(global-set-key (kbd "C-x ?") 'help-command)
(global-set-key (kbd "M-h") 'subword-backward-kill)
(global-set-key (kbd "C-M-h") 'kill-back)
