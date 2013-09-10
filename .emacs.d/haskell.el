(load "//usr/share/emacs/site-lisp/haskell-mode/haskell-mode.el")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(define-key haskell-mode-map (kbd "C-,") 'haskell-move-nested-left)
(define-key haskell-mode-map (kbd "C-.") 'haskell-move-nested-right)

(require 'haskell-unicode-input-method)
(add-hook 'haskell-mode-hook
  (lambda () (set-input-method "haskell-unicode")))

;;(global-linum-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(haskell-indent-offset 4)
 '(haskell-mode-hook (quote ((lambda nil (ghc-init)) (lambda nil (set-input-method "haskell-unicode")) turn-on-haskell-indent turn-on-haskell-doc-mode)))
 '(haskell-stylish-on-save t)
 '(haskell-tags-on-save t)
 '(yas/global-mode t nil (yasnippet))
 '(yas/root-directory (quote ("~/.emacs.d/snippets")) nil (yasnippet))
 '(yas/use-menu (quote real-modes))
 '(yas/visit-from-menu nil))


(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))
(global-set-key (kbd "C-c C-k") 'haskell-process-load-file)

(require 'speedbar)
(speedbar-add-supported-extension ".hs")
(speedbar-add-supported-extension ".vert")
(speedbar-add-supported-extension ".frag")
(speedbar-add-supported-extension ".tga")

;;(speedbar)

(global-set-key (kbd "C-c l") 'linum-mode)

(haskell-indentation-mode)

(iedit-mode)

(require 'flymake-haskell-multi)
(add-hook 'haskell-mode-hook 'flymake-haskell-multi-load)

(global-set-key (kbd "C-c e") 'hippie-expand)

;;(minimap-create)

