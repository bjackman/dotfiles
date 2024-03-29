;; TODO use use-package to tidy this shit up

;; TODO Figure out whether to make everythin use Custom or just use setq

;; TODO If I upgrade to emacs 25.1 I can just use pacakge-selected-packages to
;; do this (with Custom)
(require 'package)

;; (push '("marmalade" . "http://marmalade-repo.org/packages/")
;;       package-archives )
;;(add-to-list 'package-archives
;;             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;;(push '("melpa" . "http://melpa.milkbox.net/packages/")
;;       package-archives)
;;(push '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
;;      package-archives)

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))

(setq package-list '(helm-projectile projectile f s yaml-mode go-mode
                     solarized-theme fill-column-indicator cider dts-mode
                     evil evil-mu4e async magit tabbar-ruler ggtags evil-collection))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(global-visual-line-mode t)

;; because fuck typing 3 whole characters
(defalias 'yes-or-no-p 'y-or-n-p)

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
(global-set-key (kbd "C-c e") (lambda () (interactive) (find-file "~/dotfiles/emacs")))
(global-set-key (kbd "C-c r e") (lambda () (interactive) (load-file "~/dotfiles/emacs")))
;; so that dotfiles/emacs gets opened as emacs lisp
(setq auto-mode-alist (cons '("emacs" . emacs-lisp-mode) auto-mode-alist))

(require 'magit)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c m b") 'magit-blame)
(global-set-key (kbd "C-c m l") 'magit-log-buffer-file)
(defun brendan/magit-float-head ()
  (interactive)
  (magit-checkout (magit-rev-parse "HEAD")))
(transient-append-suffix 'magit-branch "x" '("f" "Float HEAD" brendan/magit-float-head))

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
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

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


(setq evil-want-integration t)
(setq evil-want-keybinding nil)
(require 'evil)
(evil-mode 1)
(evil-set-initial-state 'term-mode 'emacs)
(evil-set-initial-state 'undo-tree-mode 'emacs)
(evil-collection-init)

(global-undo-tree-mode t)

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
(defun evil-exit-and-save ()
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

;; M-. is useful for lispy stuff, remove it from evil stuff
(define-key evil-normal-state-map (kbd "M-.") nil)

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
(global-set-key (kbd "C-c f") 'find-function)

; Insert current filename in minibuffer with f3
(define-key minibuffer-local-map [f3]
  (lambda () (interactive)
     (insert (buffer-file-name (window-buffer (minibuffer-selected-window))))))

;; (define-key global-map "\C-cl" 'org-store-link)
;; (define-key global-map "\C-ca" 'org-agenda)
(require 'org)
(define-key org-mode-map (kbd "RET") 'org-return-indent)
(setq org-log-done t)

(add-hook 'python-mode-hook 'fci-mode)

(defun my-c-lineup-arglist-intro-after-func (langelem)
  "Line up the first argument to a function by indenting 1 step from the
beginning of the function name"
  (save-excursion
    (beginning-of-line)
    (backward-up-list 1)
    (c-backward-token-2 1)
    (current-column)))

(c-add-style "trusted-firmware"
	     '("linux"
               (indent-tabs-mode .nil)
               (c-tab-always-indent . nil)
               (tab-always-indent . nil)))

(setq c-default-style '((java-mode . "java")
                        (awk-mode . "awk")
                        (other . "linux")))

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
  ;; TODO: this will break horribly if
  ;; - you rename the serial buffer
  ;; - you have another buffer with the name of the serial path
  ;; but I never rename buffers so fuck it
  (when (get-buffer serial-path)
    (kill-buffer serial-path))
  (serial-term serial-path 115200)
  ;; (term-line-mode)
  (current-buffer))

; TODO: Instead of this, my-serial-term should just have /dev/ttyUSB0 as the
; default argument for serial-path
(defun ttys0-serial-term ()
  "Open /dev/ttyS0 with 115200 baud"
  (interactive)
  (my-serial-term "/dev/ttyS0"))
(defun ttyusb0-serial-term ()
  "Open /dev/ttyUSB0 with 115200 baud"
  (interactive)
  (my-serial-term "/dev/ttyUSB0"))

;; (global-set-key (kbd "<f6>") 'ttys0-serial-term)

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
  (if buffer-file-name
    (evil-exit-and-save))
  (compile compile-command))
(global-set-key (kbd "<f5>") 'save-exit-compile)

(defun save-run ()
  (interactive)
  (if buffer-file-name
      (save-buffer))
  (projectile-run-project nil))
(global-set-key (kbd "<f6>") 'save-run)

(define-skeleton linux-printk-skeleton
  "Inserts a Linux printk call with the function name"
  nil "printk(\"%s: " _ "\\n\", __func__\);" >) ; NEAR
                                                ; FAR
                                                ; WHEREEEEVER YOU ARE
(define-abbrev c-mode-abbrev-table "prk"
  "" 'linux-printk-skeleton)

(defun checkpatch-this-file ()
  (interactive)
  (let ((script (concat (projectile-project-root) "scripts/checkpatch.pl")))
    (let ((cmd (concat script " --no-color --emacs --file " (buffer-file-name))))
      (message cmd)
      (compile cmd))))

;; Fix some bollocks to do with pasting from other X clients into Emacs
;; I haven't read it but probably this
(setq x-selection-timeout 50)

(global-set-key (kbd "C-x O") 'other-frame)

(windmove-default-keybindings)


(defun mu4e-action-git-apply-patch (msg)
  "Apply the git [patch] message."
  (let ((path (ido-read-directory-name "Target directory: "
                                       (car ido-work-directory-list)
                                       "~/" t)))
    (setf ido-work-directory-list
          (cons path (delete path ido-work-directory-list)))
    (message (mu4e-message-field msg :path))
    (shell-command
     (format "cd %s; git am < %s"
             path
             (mu4e-message-field msg :path)))))

(defun mu4e-action-save-msg-file (msg)
  "Save the message to a file"
  (let ((path (expand-file-name (read-file-name))))
    (shell-command
     (format "cp %s; %s" (mu4e-message-field msg :path) path))))

(when (file-exists-p "~/.mu4e.el")
  ;; My ~/.mu4e.el at work looks like:

  ;; (setq user-mail-address "natahan@trashbat.cok"
  ;;       user-full-name "Nathan Barley")
  ;; (setq message-send-mail-function 'smtpmail-send-it
  ;;       smtpmail-stream-type 'starttls
  ;;       smtpmail-default-smtp-server "smtp.trashbat.cok"
  ;;       smtpmail-smtp-server "smtp.trashbat.cok"
  ;;       smtpmail-smtp-service 587)
  ;;
  ;; For my gmail:
  ;; don't save messages to Sent Messages, Gmail/IMAP takes care of this
  (setq mu4e-sent-messages-behavior 'delete)

  (require 'smtpmail)
  (global-set-key (kbd "C-c 4") (lambda () (interactive)
                                  (delete-other-windows)
                                  (mu4e)))

  (setq mu4e-maildir-shortcuts '(("/INBOX" . ?i))
        mu4e-get-mail-command "mbsync chromium"
        mu4e-update-interval 120
        message-send-mail-function 'smtpmail-send-it
        ;; I think the following are pretty standard for SMTP in 2016
        smtpmail-stream-type 'starttls
        smtpmail-smtp-service 587)

  (setq mu4e-use-fancy-chars t
        mu4e-view-show-addresses t)
  (load-file "~/.mu4e.el")
  (require 'evil-mu4e)
  (require 'mu4e)
  (evil-define-key evil-mu4e-state 'mu4e-headers-mode-map "+" 'mu4e-headers-mark-for-flag)
  (evil-define-key evil-mu4e-state 'mu4e-headers-mode-map "=" 'mu4e-headers-mark-for-unflag)

  (add-to-list 'mu4e-headers-actions
               '("Save message" . mu4e-action-save-msg-file) t)

  (add-to-list 'mu4e-headers-actions
               '("Apply patch" . mu4e-action-git-apply-patch) t))

(defun diff-mode-mu4e-mode ()
  "Switch between mu4e-view-mode and diff-mode. This is useful for mailing list patches"
  (interactive)
  (cond ((eq major-mode 'mu4e-view-mode) (diff-mode))
        ((eq major-mode 'diff-mode) (mu4e-view-mode))
        (t (message "Not in diff-mode or mu4e-view-mode"))))
(global-set-key (kbd "C-c d") 'diff-mode-mu4e-mode)

(add-hook 'dts-mode-hook (lambda ()
                           (setq indent-tabs-mode t)))

;; The default message-mode citation string is a bit sparse (it just says "Joe Bloggs writes:")
;; Make it say "On Monday, 1st Jan 2001 at 11:02, Joe Bloggs wrote:"
;; Note we don't have a newline at the end.
(setq message-citation-line-function 'message-insert-formatted-citation-line)
(setq message-citation-line-format "On %a, %b %d %Y at %R, %N wrote:")

(setq erc-autojoin-channels-alist
      '(("freenode.net" "#emacs")
        ("irc.oftc.net" "#sched")
        ("pdtl-ubuntu-1.cambridge.arm.com" "#power" "#pdsw")))

(defun brendan/start-erc ()
  "Start ERC and join the usual channels"
  (interactive)
  (erc :server "pdtl-ubuntu-1.cambridge.arm.com" :nick "bjackman")
  (erc :server "irc.oftc.net" :nick "bjackman"))
(global-set-key (kbd "C-c 5") 'brendan/start-erc)

;; For html
(setq sgml-basic-offset 4)

(defun my-go-mode-hook ()
  ; Call Gofmt before saving
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))
(add-hook 'go-mode-hook 'my-go-mode-hook)

(add-to-list 'exec-path "~/dotfiles/bin")
(add-to-list 'exec-path "~/.cargo/bin")

;; Ain't nobody use the toolbar
(tool-bar-mode -1)
;; Or the menu bar
(menu-bar-mode -1)
;; Or the scroll bars
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)
;; Ain't nobody want Emacs to minimize itself when you accidentally hit C-x C-z
(put 'suspend-frame 'disabled t)

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))

;; Don't make an annoying noise every time I try to backspace past a prompt or some shit
;; Flash the screen very annoyingly instead
(setq visible-bell nil)

;; Try to stop emacs creating those annoying .#foo backup files
(setq backup-directory-alist `(("." . "~/.saves")))

(setq custom-file "~/dotfiles/.emacs-custom.el")
(load custom-file)

(set-face-attribute 'default nil :height 120) ;; God reads in 11pt
(load-theme 'solarized-dark)
(server-start)

;;
;; BEGIN GOOGLE-SPECIFIC SHIT
;;

;; Two space indents.
(set-variable 'typescript-indent-level 2)
;; Use the Google3 version of TypeScript.
(set-variable 'tide-tsserver-directorxy
              (concat "/google/src/head/depot/google3"
                      "/third_party/javascript/node_modules"
                      "/typescript/stable/lib"))

;; 80-char indicator for C++
(add-hook 'cc-mode-hook 'display-fill-column-indicator-mode)

(require 'google3-eglot)
(google3-eglot-setup)
(add-to-list 'eglot-stay-out-of 'imenu)
;; (global-set-key (kbd "C-c g") 'fig-status)

;; https://groups.google.com/a/google.com/forum/#!topic/emacs-users/is4EzvY-mTc
(remove-hook 'find-file-hook 'p4-update-status)
(remove-hook 'find-file-hook 'google-load-p4-if-useful-hook)
(setq vc-handled-backends nil)  ;; disable vc-mode

(with-eval-after-load 'fig
  (with-eval-after-load 'evil
    (evil-define-key 'normal fig-mode-map
      (kbd "RET") 'fig-visit-thing
      (kbd "TAB") 'fig-section-toggle)
    (evil-define-key 'normal fig-status-mode-map
      "B" 'fig-bookmark-popup
      "c" 'fig-commit-popup
      "g?" 'fig-status-dispatch-popup
      "f" 'fig-fix-popup
      "F" 'fig-pull-popup
      "P" 'fig-push-popup
      "r" 'fig-rebase-popup
      "R" 'fig-mail-popup
      "T" 'fig-tag-popup
      "_" 'fig-revert-popup
      "!" 'fig-open-shell
      "z" 'fig-shelve-popup
      "`" 'fig-process-buffer
      "?" 'fig-status-dispatch-popup)))
