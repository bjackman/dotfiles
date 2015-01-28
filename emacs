(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
      package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
      package-archives)

(package-initialize)

(require 'evil)
(evil-mode 1)

(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)

(defun find-tag-at-point ()
  (interactive)
  (find-tag (thing-at-point 'symbol)))
(global-set-key (kbd "C-x p") 'find-tag-at-point)

(global-set-key (kbd "C-x g") 'magit-status)

;; (setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)
;; (ido-mode 1)

(global-set-key (kbd "C-x C-b") 'ibuffer)

(blink-cursor-mode 0)
(linum-mode 1)

;; probably won't use this..
(defun run-on-current-file (cmd)
  "Run a command, replacing %s with the name of the current buffer's file"
  (interactive "s")
  (shell-command 
  (format cmd 
    (shell-quote-argument (buffer-file-name)))))

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
