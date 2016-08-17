(require 'package)

;;(push '("marmalade" . "http://marmalade-repo.org/packages/")
;;      package-archives )
;; (push '("melpa" . "http://melpa.milkbox.net/packages/")
;;       package-archives)
(push '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
      package-archives)

(setq package-list '(helm-projectile projectile f s multi-compile
                     solarized-theme color-theme fill-column-indicator
                     evil async magit tabbar-ruler ggtags evil-magit))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(load-file "~/dotfiles/hoon-mode.el")

(global-visual-line-mode t)

;; because fuck typing 3 whole characters
(defalias 'yes-or-no-p 'y-or-n-p)

(tabbar-mode 1)
(column-number-mode 1)
(blink-cursor-mode 0)
;; (add-hook 'find-file-hook '(lambda () (linum-mode (if (buffer-file-name) 1 0))))
;; clean whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(desktop-save-mode 1)

; Maximise on startup
(add-to-list 'default-frame-alist '(fullscreen . maximized))

; Show file path in frame title
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "Emacs | %b "))))

(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))
(global-set-key (kbd "C-c /") 'comment-or-uncomment-region-or-line)

(defun arduino-terminal ()
  (interactive)
  (serial-term "/dev/ttyACM0" 9600
  (term-line-mode)))

;; open .emacs
(global-set-key (kbd "C-c e") (lambda () (interactive) (find-file user-init-file)))
(global-set-key (kbd "C-c r e") (lambda () (interactive) (load-file "~/.emacs")))
;; so that dotfiles/emacs gets opened as emacs lisp
(setq auto-mode-alist (cons '("emacs" . emacs-lisp-mode) auto-mode-alist))

(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c m b") 'magit-blame)
(global-set-key (kbd "C-c m l") 'magit-log-buffer-file)
(magit-define-popup-option 'magit-patch-popup ?S "Subject Prefix" "--subject-prefix=")

;; There's a bad interaction between vc and magit, where they compete for the
;; git lock. Workaround for that:
(remove-hook 'find-file-hooks 'vc-find-file-hook)
; Don't open another stupid frame in stupid ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(projectile-global-mode)
(setq projectile-enable-caching t)
(setq compilation-read-command nil)
(setq projectile-git-command "git ls-files -zc")
(setq projectile-switch-project-action 'projectile-commander)
(def-projectile-commander-method ?h "Run helm-projectile" (helm-projectile))

(defun multi-compile-projectile ()
  (interactive)
  (projectile-with-default-dir
      (if (projectile-project-p) (projectile-project-root) default-directory)
    (multi-compile-run)))
;; This overrides projectile-commander (which I never use)
(define-key projectile-mode-map (kbd "C-c p m") 'multi-compile-projectile)
;; Make any value safe for file-local and dir-local multi-compile-alist
(put 'multi-compile-alist 'safe-local-variable
     (lambda (x) t))
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
;; (evil-set-initial-state 'magit-popup-mode 'emacs)
;; (evil-set-initial-state 'magit-status-mode 'emacs)
;; (evil-set-initial-state 'git-rebase-mode 'emacs)
;; (evil-set-initial-state 'dired-mode 'emacs)
;; (evil-set-initial-state 'magit-blame-mode 'emacs)
(require 'evil-magit)

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
(defun exit-evil-and-save ()
  (interactive)
  (evil-normal-state)
  (save-buffer))

;; Evil: Make movement keys use soft lines instead of hard
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)

(define-key evil-normal-state-map (kbd "W") 'forward-symbol)
(defun backward-symbol (&optional arg)
  "From .emacs"
  (interactive "p")
  (forward-symbol (- (or arg 1))))
(define-key evil-normal-state-map (kbd "B") 'backward-symbol)

; Make horizontal movement cross lines
(setq-default evil-cross-lines t)

;; There has to be a quicker way to do this..
(define-key evil-normal-state-map (kbd "TAB")
  (lambda () (interactive)
    (save-excursion
      (back-to-indentation)
      (indent-for-tab-command))))

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
(global-set-key (kbd "C-c r b") 'revert-buffer)
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
     (insert (buffer-file-name (window-buffer (minibuffer-selected-window))))))

;; (define-key global-map "\C-cl" 'org-store-link)
;; (define-key global-map "\C-ca" 'org-agenda)
(require 'org)
(define-key org-mode-map (kbd "RET") 'org-return-indent)
(setq org-log-done t)

(add-hook 'c-mode-hook 'fci-mode)
(add-hook 'python-mode-hook 'fci-mode)

(defun my-c-lineup-arglist-intro-after-func (langelem)
  "Line up the first argument to a function by indenting 1 step from the
beginning of the function name"
  (save-excursion
    (beginning-of-line)
    (backward-up-list 1)
    (c-backward-token-2 1)
    (current-column)))

(c-add-style "scp"
	     '("linux"
	       (c-basic-offset . 4)	; Guessed value
	       (indent-tabs-mode . nil)
	       (c-offsets-alist
		(arglist-cont . 0)	; Guessed value
		(arglist-intro . my-c-lineup-arglist-intro-after-func)
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

(c-add-style "trusted-firmware"
	     '("scp"
	       (c-basic-offset . 8)
               (indent-tabs-mode .nil)
               (c-tab-always-indent . nil)
               (tab-always-indent . nil)))

(c-add-style "adafruit"
	     '("scp"
	       (c-basic-offset . 2)))

(when (boundp 'save-some-buffers-action-alist)
  (setq save-some-buffers-action-alist
        (cons
         (list
          ?%
          #'(lambda (buf)
              (with-current-buffer buf
                (set-buffer-modified-p nil))
              nil)
          "mark buffer unmodified.")
         (cons
          (list
           ?,
           #'(lambda (buf)
               (with-current-buffer buf
                 (revert-buffer t))
               nil)
           "revert buffer.")
          save-some-buffers-action-alist))))

(defun reload-dir-locals-all-buffers ()
  "Reload dir-locals for all buffers"
  (interactive)
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (hack-dir-local-variables-non-file-buffer))))

(global-set-key (kbd "C-c r d") 'reload-dir-locals-all-buffers)

(defun my-serial-term (serial-path)
  "Open a serial file at 115200 baud and put the buffer in line mode (otherwise
it swallows keypresses)"
  (interactive "fserial file: ")
  (serial-term serial-path 115200)
  (term-line-mode)
  (current-buffer))

; TODO: Instead of this, my-serial-term should just have /dev/ttyUSB0 as the
; default argument for serial-path
(defun ttys0-serial-term ()
  "Open /dev/ttyS0 with 115200 baud"
  (interactive)
  (my-serial-term "/dev/ttyS0"))

(defvar arduino-serial-buffer nil)
(defvar arduino-serial-file nil)
(put 'arduino-serial-file 'safe-local-variable (lambda (x) t))
(defun arduino-terminal (compilation-buffer result-str)
  (message "arduino-terminal called")
  (setq arduino-serial-buffer (my-serial-term arduino-serial-file)))

(defun arduino-go ()
  "Compile and upload an Arduino program with Arduino.mk"
  (interactive)
  (let ((compilation-finish-functions '(arduino-terminal)))
    (when arduino-serial-buffer (kill-buffer arduino-serial-buffer))
    (compile "make upload")))

(defun save-exit-compile ()
  (interactive)
  (exit-evil-and-save)
  (projectile-compile-project))
(global-set-key (kbd "<f5>") 'save-exit-compile)

(define-skeleton linux-printk-skeleton
  "Inserts a Linux printk call with the function name"
  nil "printk(\"%s: " _ "\\n\", __func__\);" >) ; NEAR
                                                ; FAR
                                                ; WHEREEEEVER YOU ARE
(define-abbrev c-mode-abbrev-table "prk"
  "" 'linux-printk-skeleton)

(global-set-key (kbd "C-x O") 'other-frame)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(compilation-always-kill t)
 '(compilation-auto-jump-to-first-error t)
 '(compilation-message-face (quote default))
 '(compilation-scroll-output (quote first-error))
 '(compilation-skip-threshold 2)
 '(confirm-kill-emacs (quote y-or-n-p))
 '(custom-safe-themes
   (quote
    ("71ecffba18621354a1be303687f33b84788e13f40141580fa81e7840752d31bf" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(ediff-split-window-function (quote split-window-horizontally))
 '(fci-rule-color "#073642")
 '(fill-column 80)
 '(inhibit-startup-screen t)
 '(make-backup-files nil)
 '(multi-compile-completion-system (quote helm))
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
 '(package-selected-packages
   (quote
    (ggtags fill-column-indiciator fill-column-indicator tabbar-ruler solarized-theme magit helm-projectile guide-key f evil color-theme buffer-move)))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(projectile-use-git-grep t)
 '(require-final-newline t)
 '(standard-indent 4)
 '(vc-follow-symlinks t))

(set-face-attribute 'default nil :height 110) ;; God reads in 11pt
(load-theme 'solarized-dark)
(server-start)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
