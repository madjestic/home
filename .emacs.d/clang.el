;; Turn on auto-complete-clang-async
(add-to-list 'load-path "~/.emacs.d/auto-complete-clang-async")
(require 'auto-complete-clang-async)
(setq clang-completion-suppress-error 't)

(defun ac-cc-mode-setup ()
  (setq ac-clang-complete-executable "~/.emacs.d/auto-complete-clang-async/clang-complete")
  (setq ac-clang-cflags
    (mapcar (lambda (item)(concat "-I" item))
            (split-string
               "/opt/hfs-12.5.427/toolkit/include
                /usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4
                /usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/x86_64-pc-linux-gnu
                /usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include/g++-v4/backward
                /usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include
                /usr/lib/gcc/x86_64-pc-linux-gnu/4.4.5/include-fixed
                /usr/include")))
  (setq ac-sources '(ac-source-clang-async))
  (ac-clang-launch-completion-process))

(defun my-ac-config ()
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))

(my-ac-config)
