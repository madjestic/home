(semantic-mode t)
(global-ede-mode t)
(ede-enable-generic-projects)
(global-semantic-idle-summary-mode t)
;;(global-linum-mode t)


(require 'semantic/ia)
(require 'semantic/bovine/gcc)

(defun my-semantic-hook ()
  (imenu-add-to-menubar "TAGS"))
(add-hook 'semantic-init-hooks 'my-semantic-hook)

;; if you want to enable support for gnu global
;; (when (cedet-gnu-global-version-check t)
(semanticdb-enable-gnu-global-databases 'c-mode)
(semanticdb-enable-gnu-global-databases 'c++-mode)

;; enable ctags for some languages:
;;  Unix Shell, Perl, Pascal, Tcl, Fortran, Asm
;; (when (cedet-ectag-version-check)
;;(semantic-load-enable-primary-exuberent-ctags-support)

(require 'speedbar)
(speedbar-add-supported-extension ".hs")
(speedbar-add-supported-extension ".vert")
(speedbar-add-supported-extension ".frag")
(speedbar-add-supported-extension ".tga")
(speedbar-add-supported-extension ".glsl")

;;(speedbar)

;;(global-set-key (kbd "C-c l") 'linum-mode)


(load-user-file "cedet.el")

;;(load-user-file "ecb.el")

(minimap-create)

