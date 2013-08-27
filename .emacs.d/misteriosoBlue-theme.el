(deftheme misteriosoBlue
  "Created 2013-07-16.")

(custom-theme-set-variables
 'misteriosoBlue
 '(ansi-color-names-vector ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"]))

(custom-theme-set-faces
 'misteriosoBlue
 '(cursor ((((class color) (min-colors 89)) (:background "#415160"))))
 '(fringe ((((class color) (min-colors 89)) (:background "#2e3748"))))
 '(highlight ((t (:background "RoyalBlue3" :foreground "#e1e1e0"))))
 '(region ((((class color) (min-colors 89)) (:background "#2d4948" :foreground "#e1e1e0"))))
 '(isearch ((((class color) (min-colors 89)) (:background "#fcffad" :foreground "#000000"))))
 '(lazy-highlight ((((class color) (min-colors 89)) (:background "#338f86"))))
 '(trailing-whitespace ((((class color) (min-colors 89)) (:background "#ff4242"))))
 '(mode-line ((((class color) (min-colors 89)) (:background "#212931" :foreground "#eeeeec"))))
 '(mode-line-inactive ((((class color) (min-colors 89)) (:background "#878787" :foreground "#eeeeec"))))
 '(header-line ((((class color) (min-colors 89)) (:background "#e5e5e5" :foreground "#333333"))))
 '(minibuffer-prompt ((t (:foreground "#729fcf" :weight bold))))
 '(font-lock-builtin-face ((t nil)))
 '(font-lock-comment-face ((((class color) (min-colors 89)) (:foreground "#74af68"))))
 '(font-lock-constant-face ((((class color) (min-colors 89)) (:foreground "#008b8b"))))
 '(font-lock-function-name-face ((t (:foreground "#92bfef" :weight bold))))
 '(font-lock-keyword-face ((((class color) (min-colors 89)) (:foreground "#ffad29" :weight bold))))
 '(font-lock-string-face ((((class color) (min-colors 89)) (:foreground "#e67128"))))
 '(font-lock-type-face ((t (:foreground "#82afdf"))))
 '(font-lock-variable-name-face ((((class color) (min-colors 89)) (:foreground "#dbdb95"))))
 '(font-lock-warning-face ((((class color) (min-colors 89)) (:foreground "#ff4242" :weight bold))))
 '(button ((((class color) (min-colors 89)) (:underline t))))
 '(link ((((class color) (min-colors 89)) (:foreground "#fe99ff" :underline (:color nil :style nil)))))
 '(link-visited ((((class color) (min-colors 89)) (:foreground "#ed74cd" :underline t))))
 '(default ((((class color) (min-colors 4096)) (:background "#2d3743" :foreground "#e1e1e0")) (((class color) (min-colors 89)) (:background "#3a3a3a" :foreground "#e1e1e0")))))

(provide-theme 'misteriosoBlue)
