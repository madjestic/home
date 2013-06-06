(load "//usr/share/emacs/site-lisp/haskell-mode/haskell-mode.el")
;;//usr/share/emacs/site-lisp/haskell-mode/haskell-mode.el
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)

;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

(global-linum-mode t)

(add-to-list 'load-path "/path/to/color-theme")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-gray30)))
(custom-set-variables
'(tool-bar-mode nil))

(custom-set-faces
'(scroll-bar ((t (:background "gray30" :foreground "dim gray" :width condensed)))))

;; (scroll-bar-mode -1)
(set-scroll-bar-mode 'right)

