(require 'package)

;;(push '("marmalade" . "http://marmalade-repo.org/packages/")
;;      package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
      package-archives)

(setq package-list '(helm-projectile projectile f s
                     solarized-theme color-theme fill-column-indicator
                     evil async magit tabbar-ruler helm-gtags))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(load-file "~/dotfiles/hoon-mode.el")

(global-visual-line-mode t)

(setq inhibit-startup-message t)
;; because fuck typing 3 whole characters
(defalias 'yes-or-no-p 'y-or-n-p)

(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

(tabbar-mode 1)
(column-number-mode 1)
(blink-cursor-mode 0)
(add-hook 'find-file-hook '(lambda () (linum-mode (if (buffer-file-name) 1 0))))
;; clean whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(desktop-save-mode 1)

; Maximise on startup
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq indent-tabs-mode nil)

; Show file path in frame title
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "Emacs | %b "))))

(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(require 'helm-gtags)
(define-key helm-gtags-mode-map (kbd "C-c t") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "C-c 4 t") 'helm-gtags-find-tag-other-window)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
;; http://tuhdo.github.io/c-ide.html#sec-1 for more
(add-hook 'c-mode-common-hook 'helm-gtags-mode)

(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))
(global-set-key (kbd "C-c /") 'comment-or-uncomment-region-or-line)

;; open .emacs
(global-set-key (kbd "C-c e") (lambda () (interactive) (find-file user-init-file)))
(global-set-key (kbd "C-c C-r") (lambda () (interactive) (load-file "~/.emacs")))
;; so that dotfiles/emacs gets opened as emacs lisp
(setq auto-mode-alist (cons '("emacs" . emacs-lisp-mode) auto-mode-alist))
; Don't ask before following symlinks to source controlled files
(setq vc-follow-symlinks t)


(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c m b") 'magit-blame)
(global-set-key (kbd "C-c m b") 'magit-blame)
(global-set-key (kbd "C-c q") 'magit-blame-quit)

; Don't open another stupid frame in stupid ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(projectile-global-mode)
(setq projectile-enable-caching t)
(setq compilation-read-command nil)
(setq projectile-git-command "git ls-files -zc")
(setq projectile-switch-project-action 'projectile-commander)

(defun multi-compile-projectile ()
  (interactive)
  (projectile-with-default-dir
      (if (projectile-project-p) (projectile-project-root) default-directory)
    (multi-compile-run)))
;; This overrides projectile-commander (which I never use)
(define-key projectile-mode-map (kbd "C-c p m") 'multi-compile-projectile)
;; Example dir-locals.el:
;; ((nil
;;   (multi-compile-alist . (("\\.*" ("name" . "command1") ("name2" . "command2"))))
;;   (c-file-style . "scp")))

;; Live syntax checking for c
;;(add-hook 'c-mode-hook 'flycheck-mode)

(require 'cc-mode)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)

(require 'python)
(define-key python-mode-map (kbd "RET") 'newline-and-indent)

;; Enable pandoc mode when editing markdown
(add-hook 'markdown-mode-hook 'pandoc-mode)
;; Word wrap when editing markdown
(add-hook 'markdown-mode-hook 'visual-line-mode)


(require 'evil)
(evil-mode 1)
(evil-set-initial-state 'magit-popup-mode 'emacs)
(evil-set-initial-state 'magit-status-mode 'emacs)
(evil-set-initial-state 'git-rebase-mode 'emacs)
(evil-set-initial-state 'dired-mode 'emacs)
(evil-set-initial-state 'magit-blame-mode 'emacs)

;; No fucking idea how this works, but it maps kj to exit insert mode in Evil. Apparently.
(define-key evil-insert-state-map "k" #'cofi/maybe-exit)
(evil-define-command cofi/maybe-exit ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "k")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?j)
               nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?j))
    (delete-char -1)
    (set-buffer-modified-p modified)
    (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                          (list evt))))))))

;; Evil: Make movement keys use soft lines instead of hard
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)

; Make horizontal movement cross lines
(setq-default evil-cross-lines t)


(require 'tex-mode)
(defun latex-word-count ()
  (interactive)
  (shell-command (concat "texcount '" (buffer-file-name) "'")))
(define-key latex-mode-map "\C-cw" 'latex-word-count)
(add-hook 'tex-mode-hook 'pandoc-mode)

(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

(global-set-key (kbd "C-c A") 'align-regexp)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-c w") 'whitespace-mode)
(global-set-key (kbd "C-c c") 'compile)
(global-set-key (kbd "C-c k") 'woman)
(global-set-key (kbd "C-c s") 'sort-lines)
(global-set-key (kbd "C-c i") 'imenu)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c f") 'ffap)

; Insert current filename in minibuffer with f3
(define-key minibuffer-local-map [f3]
  (lambda () (interactive)
     (insert (buffer-name (window-buffer (minibuffer-selected-window))))))

;; (define-key global-map "\C-cl" 'org-store-link)
;; (define-key global-map "\C-ca" 'org-agenda)
(require 'org)
(define-key org-mode-map (kbd "RET") 'org-return-indent)
(setq org-log-done t)

(add-hook 'c-mode-hook 'fci-mode)
(add-hook 'python-mode-hook 'fci-mode)

(c-add-style "scp"
	     '("linux"
	       (c-basic-offset . 4)	; Guessed value
	       (indent-tabs-mode . nil)
	       (c-offsets-alist
		(arglist-cont . 0)	; Guessed value
		(arglist-intro . 0)	; Guessed value
		(block-close . 0)	; Guessed value
		(brace-list-close . 0)	; Guessed value
		(brace-list-entry . 0)	; Guessed value
		(brace-list-intro . +)	; Guessed value
		(brace-list-open . 0)	; Guessed value
		(case-label . 0)	; Guessed value
		(class-close . 0)	; Guessed value
		(defun-block-intro . +)	; Guessed value
		(defun-close . 0)	; Guessed value
		(defun-open . 0)	; Guessed value
		(else-clause . 0)	; Guessed value
		(inclass . +)		; Guessed value
		(statement . 0)		    ; Guessed value
		(statement-block-intro . +) ; Guessed value
		(statement-case-intro . +) ; Guessed value
		(statement-cont . +)	   ; Guessed value
		(substatement . +)	   ; Guessed value
		(topmost-intro . 0)	   ; Guessed value
		(access-label . -)
		(annotation-top-cont . 0)
		(annotation-var-cont . +)
		(arglist-close . c-lineup-close-paren)
		(arglist-cont-nonempty . c-lineup-arglist)
		(block-open . 0)
		(brace-entry-open . 0)
		(c . c-lineup-C-comments)
		(catch-clause . 0)
		(class-open . 0)
		(comment-intro . c-lineup-comment)
		(composition-close . 0)
		(composition-open . 0)
		(cpp-define-intro c-lineup-cpp-define +)
		(cpp-macro . -1000)
		(cpp-macro-cont . +)
		(do-while-closure . 0)
		(extern-lang-close . 0)
		(extern-lang-open . 0)
		(friend . 0)
		(func-decl-cont . +)
		(incomposition . +)
		(inexpr-class . +)
		(inexpr-statement . +)
		(inextern-lang . +)
		(inher-cont . c-lineup-multi-inher)
		(inher-intro . +)
		(inlambda . c-lineup-inexpr-block)
		(inline-close . 0)
		(inline-open . +)
		(inmodule . +)
		(innamespace . +)
		(knr-argdecl . 0)
		(knr-argdecl-intro . +)
		(label . 2)
		(lambda-intro-cont . +)
		(member-init-cont . c-lineup-multi-inher)
		(member-init-intro . +)
		(module-close . 0)
		(module-open . 0)
		(namespace-close . 0)
		(namespace-open . 0)
		(objc-method-args-cont . c-lineup-ObjC-method-args)
		(objc-method-call-cont c-lineup-ObjC-method-call-colons c-lineup-ObjC-method-call +)
		(objc-method-intro .
				   [0])
		(statement-case-open . 0)
		(stream-op . c-lineup-streamop)
		(string . -1000)
		(substatement-label . 2)
		(substatement-open . +)
		(template-args-cont c-lineup-template-args +)
		(topmost-intro-cont . c-lineup-topmost-intro-cont))))

(setq c-default-style "scp")

(defun reload-dir-locals-all-buffers ()
  "Reload dir-locals for all buffers"
  (interactive)
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (hack-dir-local-variables-non-file-buffer))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-lock-comment-prefix "* ")
 '(c-offsets-alist (quote ((statement-cont . c-lineup-assignments))))
 '(c-tab-always-indent nil)
 '(compilation-always-kill t)
 '(compilation-auto-jump-to-first-error t)
 '(compilation-scroll-output (quote first-error))
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(ediff-split-window-function (quote split-window-horizontally))
 '(fill-column 80)
 '(multi-compile-completion-system (quote helm))
 '(package-selected-packages
   (quote
    (fill-column-indiciator fill-column-indicator tabbar-ruler solarized-theme magit helm-projectile helm-gtags guide-key f evil dired-subtree color-theme buffer-move)))
 '(require-final-newline t)
 '(standard-indent 4))

(set-face-attribute 'default nil :height 110) ;; God reads in 11pt
(load-theme 'solarized-dark)
(server-start)
