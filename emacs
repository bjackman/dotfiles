(require 'package)

(push '("marmalade" . "http://marmalade-repo.org/packages/")
      package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
      package-archives)

(setq package-list '(helm-projectile projectile f s cider
                     clojure-mode color-theme-monokai
                     color-theme-solarized color-theme dash evil
                     goto-chg helm async magit git-rebase-mode
                     git-commit-mode markdown-mode pandoc-mode
                     pkg-info epl queue undo-tree flycheck tabbar-ruler helm-gtags))

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
(global-set-key (kbd "C-x e") (lambda () (interactive) (find-file user-init-file)))

(global-set-key (kbd "C-x i") 'imenu)

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
(global-set-key (kbd "C-x /") 'comment-or-uncomment-region-or-line)

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

(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)

;; http://tuhdo.github.io/c-ide.html#sec-1 for more
(add-hook 'c-mode-hook 'helm-gtags-mode)

(require 'helm-gtags)
(define-key helm-gtags-mode-map (kbd "C-c t") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

;; the following is hopefully obsoleted by helm-gtags
;; navigate to the definition of the symbol at point.
;; use C-u C-space to go back
;; (defun find-tag-at-point ()
;;   (interactive)
;;   (find-tag (thing-at-point 'symbol)))
;; (defun find-tag-at-point-other-window ()
;;   (interactive)
;;   (find-tag-other-window (thing-at-point 'symbol)))

(global-set-key (kbd "C-x g") 'magit-status)

(global-set-key (kbd "C-x C-b") 'ibuffer)

(projectile-mode 1)
(setq projectile-enable-caching t)
(global-set-key (kbd "C-x C-h") 'projectile-find-other-file-other-window)
(global-set-key (kbd "C-x C-p") 'projectile-find-file-other-window)
(setq compilation-read-command nil)
(global-set-key (kbd "C-x c") 'projectile-compile-project)


(blink-cursor-mode 0)

;; clean whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(add-hook 'projectile-find-file-hook
  '(lambda () (setq compile-command
    (concat "make -C " (projectile-get-project-directories)))))

(add-hook 'find-file-hook '(lambda () (linum-mode (if (buffer-file-name) 1 0))))

;; disable Evil mode in git rebase mode (which has its own bindings)
(add-hook 'git-rebase-mode-hook '(lambda () (evil-mode 0)))
;; probably won't use this..
(defun run-on-current-file (cmd)
  "Run a command, replacing %s with the name of the current buffer's file"
  (interactive "s")
  (shell-command
  (format cmd
    (shell-quote-argument (buffer-file-name)))))

;; Live syntax checking for c
;;(add-hook 'c-mode-hook 'flycheck-mode)

(setq-default c-basic-offset 2)
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

(global-set-key (kbd "C-x C-r") (lambda () (interactive) (load-file "~/.emacs")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-default-style (quote ((java-mode . "java"))))
 '(custom-safe-themes (quote ("fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(ede-project-directories (quote ("/home/brendan/little")))
 '(indent-tabs-mode nil)
 '(require-final-newline t)
 '(standard-indent 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme 'solarized-dark)
