;; TODO Come on, there has to be a way to get Custom to format this properly.
;; I can format it myself but Custom just overwrites it when I change anything.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(auto-save-default nil)
 '(compilation-always-kill t)
 '(compilation-auto-jump-to-first-error t)
 '(compilation-error-regexp-alist
   (quote
    (google3-build-log-parser-info google3-build-log-parser-warning google3-build-log-parser-error google3-build-log-parser-python-traceback google-blaze-error google-blaze-warning google-log-error google-log-warning google-log-info google-log-fatal-message google-forge-python gunit-stack-trace absoft ada aix ant bash borland python-tracebacks-and-caml cmake cmake-info comma cucumber msft edg-1 edg-2 epc ftnchek iar ibm irix java jikes-file maven jikes-line clang-include clang-include gcc-include ruby-Test::Unit gnu lcc makepp mips-1 mips-2 msft omake oracle perl php rxp sparc-pascal-file sparc-pascal-line sparc-pascal-example sun sun-ada watcom 4bsd gcov-file gcov-header gcov-nomark gcov-called-line gcov-never-called perl--Pod::Checker perl--Test perl--Test2 perl--Test::Harness weblint guile-file guile-line)))
 '(compilation-message-face (quote default))
 '(compilation-scroll-output (quote first-error))
 '(compilation-skip-threshold 0)
 '(compile-command "make -j30")
 '(confirm-kill-emacs (quote y-or-n-p))
 '(custom-safe-themes
   (quote
    ("d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "71ecffba18621354a1be303687f33b84788e13f40141580fa81e7840752d31bf" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(delete-trailing-lines nil)
 '(dired-dwim-target t)
 '(dired-hide-details-hide-symlink-targets nil)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(evil-emacs-state-modes
   (quote
    (archive-mode bbdb-mode biblio-selection-mode bookmark-bmenu-mode bookmark-edit-annotation-mode browse-kill-ring-mode bzr-annotate-mode calc-mode cfw:calendar-mode completion-list-mode Custom-mode debugger-mode delicious-search-mode desktop-menu-blist-mode desktop-menu-mode doc-view-mode dvc-bookmarks-mode dvc-diff-mode dvc-info-buffer-mode dvc-log-buffer-mode dvc-revlist-mode dvc-revlog-mode dvc-status-mode dvc-tips-mode ediff-mode ediff-meta-mode efs-mode Electric-buffer-menu-mode emms-browser-mode emms-mark-mode emms-metaplaylist-mode emms-playlist-mode ess-help-mode etags-select-mode fj-mode gc-issues-mode gdb-breakpoints-mode gdb-disassembly-mode gdb-frames-mode gdb-locals-mode gdb-memory-mode gdb-registers-mode gdb-threads-mode gist-list-mode gnus-article-mode gnus-browse-mode gnus-group-mode gnus-server-mode gnus-summary-mode google-maps-static-mode ibuffer-mode jde-javadoc-checker-report-mode magit-popup-mode magit-popup-sequence-mode magit-branch-manager-mode magit-commit-mode magit-key-mode magit-rebase-mode magit-wazzup-mode mh-folder-mode monky-mode mu4e-main-mode mu4e-headers-mode mu4e-view-mode notmuch-hello-mode notmuch-search-mode notmuch-show-mode occur-mode org-agenda-mode package-menu-mode pdf-outline-buffer-mode pdf-view-mode proced-mode rcirc-mode rebase-mode recentf-dialog-mode reftex-select-bib-mode reftex-select-label-mode reftex-toc-mode sldb-mode slime-inspector-mode slime-thread-control-mode slime-xref-mode sr-buttons-mode sr-mode sr-tree-mode sr-virtual-mode tar-mode tetris-mode tla-annotate-mode tla-archive-list-mode tla-bconfig-mode tla-bookmarks-mode tla-branch-list-mode tla-browse-mode tla-category-list-mode tla-changelog-mode tla-follow-symlinks-mode tla-inventory-file-mode tla-inventory-mode tla-lint-mode tla-logs-mode tla-revision-list-mode tla-revlog-mode tla-tree-lint-mode tla-version-list-mode twittering-mode urlview-mode vc-annotate-mode vc-dir-mode vc-git-log-view-mode vc-hg-log-view-mode vc-svn-log-view-mode vm-mode vm-summary-mode w3m-mode wab-compilation-mode xgit-annotate-mode xgit-changelog-mode xgit-diff-mode xgit-revlog-mode xhg-annotate-mode xhg-log-mode xhg-mode xhg-mq-mode xhg-mq-sub-mode xhg-status-extra-mode)))
 '(fci-rule-color "#073642")
 '(fill-column 80)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(magit-log-arguments (quote ("--decorate" "-n256")))
 '(magit-patch-arguments (quote ("--cover-letter")))
 '(make-backup-files nil)
 '(message-kill-buffer-on-exit nil)
 '(mouse-wheel-progressive-speed nil)
 '(multi-compile-completion-system (quote helm))
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
 '(package-selected-packages
   (quote
    (go-mode gnuplot-mode rust-mode rust-auto-use ggtags fill-column-indiciator fill-column-indicator tabbar-ruler solarized-theme magit helm-projectile guide-key f evil color-theme buffer-move)))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(projectile-project-root-files
   (quote
    ("rebar.config" "project.clj" "build.boot" "deps.edn" "SConstruct" "pom.xml" "build.sbt" "gradlew" "build.gradle" ".ensime" "Gemfile" "requirements.txt" "setup.py" "pyproject.toml" "tox.ini" "composer.json" "Cargo.toml" "mix.exs" "stack.yaml" "info.rkt" "DESCRIPTION" "TAGS" "GTAGS" "configure.in" "configure.ac" "cscope.out" "OWNERS")))
 '(projectile-use-git-grep t)
 '(require-final-newline t)
 '(safe-local-variable-values
   (quote
    ((compilation-environment "ARCH=arm64" "CCACHE_DIR=/home/brendan/.ccache" "CROSS_COMPILE=ccache /opt/gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-")
     (compilation-environment "ARCH=arm64" "CCACHE_DIR=/work/ccache" "CROSS_COMPILE=ccache /opt/gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-")
     (compilation-environment "ARCH=arm64" "CCACHE_DIR=/work/ccache" "CROSS_COMPILE=ccache /opt/gcc-linaro-6.2.1-2016.11-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-")
     (compilation-environment "PYTHONPATH=/home/brendan/sources/lisa/libs/utils/:/home/brendan/sources/lisa/libs/wlgen/:/home/brendan/sources/lisa/libs/devlib:/home/brendan/sources/lisa/libs/trappy:/home/brendan/sources/lisa/libs/bart")
     (compilation-environment "PYTHONPATH=/home/brendan/sources/lisa/libs/utils/:/home/brendan/sources/lisa/libs/wlgen/:/home/brendan/sources/lisa/")
     (compilation-environment "ARCH=arm64" "CCACHE_DIR=/work/ccache" "CROSS_COMPILE=ccache /opt/gcc-linaro-4.9-2015.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-")
     (compilation-environment "ARCH=arm64" "CCACHE_DIR=/work/ccache" "CROSS_COMPILE=ccache aarch64-linux-gnu-")
     (eval progn
           (require
            (quote projectile))
           (puthash
            (projectile-project-root)
            "nosetests" projectile-test-cmd-map))
     (c-default-style . "linux")
     (indent-tabs-mode t)
     (compilation-environment "ARCH=arm64" "CROSS_COMPILE=aarch64-linux-gnu-"))))
 '(sgml-basic-offset 4 t)
 '(split-height-threshold 200)
 '(standard-indent 4)
 '(vc-follow-symlinks t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
