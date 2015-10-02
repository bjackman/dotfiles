(require 'package)

(push '("marmalade" . "http://marmalade-repo.org/packages/")
      package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
      package-archives)

(setq package-list '(helm-projectile projectile f s
                     color-theme-monokai solarized-theme color-theme
                     evil async magit tabbar-ruler helm-gtags
                     buffer-move dired-subtree guide-key))

(global-visual-line-mode t)

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


(setq inhibit-startup-message t)
;; because fuck typing 3 whole characters
(defalias 'yes-or-no-p 'y-or-n-p)

;; so that dotfiles/emacs gets opened as emacs lisp
(setq auto-mode-alist (cons '("emacs" . emacs-lisp-mode) auto-mode-alist))

;; open .emacs
(global-set-key (kbd "C-c e") (lambda () (interactive) (find-file user-init-file)))

(global-set-key (kbd "C-c i") 'imenu)

(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))
(global-set-key (kbd "C-c /") 'comment-or-uncomment-region-or-line)

;; enable saving recent files
(require 'recentf)
(setq recentf-max-saved-items 200
      recentf-max-menu-items 15)
(recentf-mode +1)

;; C-k usually kills a line but we are Evil so let's bind it to
;; quickly killing a buffer (without asking yes or no)
(global-set-key (kbd "C-k") (lambda () (interactive) (kill-buffer (buffer-name))))

(tabbar-mode 1)
(evil-mode 1)
(column-number-mode 1)

(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)

;; http://tuhdo.github.io/c-ide.html#sec-1 for more
(add-hook 'c-mode-hook 'helm-gtags-mode)

(require 'helm-gtags)
(define-key helm-gtags-mode-map (kbd "C-c t") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c m b") 'magit-blame)
(global-set-key (kbd "C-c m b") 'magit-blame)
(global-set-key (kbd "C-c q") 'magit-blame-quit)

(global-set-key (kbd "C-x C-b") 'ibuffer)

(projectile-global-mode)
(setq projectile-enable-caching t)
(setq compilation-read-command nil)

(blink-cursor-mode 0)

(setq projectile-switch-project-action 'neotree-projectile-action)
(global-set-key (kbd "C-c n") (lambda () (interactive)
                                                (neotree-toggle)
                                                 (projectile-project-root)))


; Nope: projectile-run-shell-command-in-root doesn't take an argument
(define-key projectile-mode-map (kbd "C-c p d")
  (lambda () (interactive)
    (projectile-run-shell-command-in-root "make clean")))

;; clean whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(add-hook 'find-file-hook '(lambda () (linum-mode (if (buffer-file-name) 1 0))))

;; disable Evil mode in some modes
(evil-set-initial-state 'git-rebase-mode 'emacs)
(evil-set-initial-state 'dired-mode 'emacs)
(evil-set-initial-state 'neotree-mode 'emacs)
(evil-set-initial-state 'magit-blame-mode 'emacs)

;; probably won't use this..
(defun run-on-current-file (cmd)
  "Run a command, replacing %s with the name of the current buffer's file"
  (interactive "s")
  (shell-command
  (format cmd
    (shell-quote-argument (buffer-file-name)))))

;; Live syntax checking for c
;;(add-hook 'c-mode-hook 'flycheck-mode)

(require 'cc-mode)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)

;; Enable pandoc mode when editing markdown
(add-hook 'markdown-mode-hook 'pandoc-mode)

;; Word wrap when editing markdown
(add-hook 'markdown-mode-hook 'visual-line-mode)

(add-hook 'python-mode-hook '(lambda ()
  (local-set-key (kbd "RET") 'newline-and-indent)))

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

(require 'tex-mode)
(defun latex-word-count ()
  (interactive)
  (shell-command (concat "texcount '" (buffer-file-name) "'")))
(define-key latex-mode-map "\C-cw" 'latex-word-count)
(add-hook 'tex-mode-hook 'pandoc-mode)


;; Evil: Make movement keys use soft lines instead of hard
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
; Make horizontal movement cross lines (not sure what that means tbh)
(setq-default evil-cross-lines t)

(global-set-key (kbd "C-c C-r") (lambda () (interactive) (load-file "~/.emacs")))

(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

(define-key dired-mode-map (kbd "i") 'dired-subtree-insert)
(define-key dired-mode-map (kbd "k") 'dired-subtree-remove)
(define-key dired-mode-map (kbd "^") 'dired-subtree-up)

(setq guide-key/guide-key-sequence '("C-c p"))
(guide-key-mode 1)

; Maximise on startup
(add-to-list 'default-frame-alist '(fullscreen . maximized))

; Don't ask before following symlinks to source controlled files
(setq vc-follow-symlinks t)

(defun kill-other-buffers ()
    "Kill all buffers except the current one."
    (interactive)
    (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(global-set-key (kbd "C-c a") 'align-regexp)
(global-set-key (kbd "C-c r") 'revert-buffer)

; Show file path in frame title
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b | Emacs"))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-block-comment-prefix "* ")
 '(c-default-style (quote ((java-mode . "java") (awk-mode . "awk"))))
 '(c-offsets-alist (quote ((statement-cont . c-lineup-assignments))))
 '(c-tab-always-indent nil)
 '(compilation-always-kill t)
 '(compilation-auto-jump-to-first-error t)
 '(compilation-scroll-output (quote first-error))
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(delete-trailing-lines nil)
 '(ede-project-directories (quote ("/home/brendan/little")))
 '(indent-tabs-mode nil)
 '(require-final-newline t)
 '(safe-local-variable-values
   (quote
    ((projectile-project-compilation-cmd . "make PLATFORM=armstrong MODE=debug TOOLCHAIN=GCC GCC32_TOOLCHAIN=arm-none-eabi-")
     (c-block-comment-prefix . "* ")
     (c-basic-ofsset . 4)
     (projectile-project-compilation-cmd . "make PLATFORM=buzz_testbench MODE=debug TOOLCHAIN=GCC GCC32_TOOLCHAIN=arm-none-eabi-"))))
 '(standard-indent 4))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-subtree-depth-1-face ((t (:background "gray90"))))
 '(dired-subtree-depth-2-face ((t (:background "gray80"))))
 '(dired-subtree-depth-3-face ((t (:background "gray70"))))
 '(dired-subtree-depth-4-face ((t (:background "gray60"))))
 '(dired-subtree-depth-5-face ((t (:background "gray50"))))
 '(dired-subtree-depth-6-face ((t (:background "gray40")))))

(load-theme 'solarized-dark)
