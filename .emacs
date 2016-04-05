(custom-set-variables
    '(blink-cursor nil)
    '(menu-bar-mode 0)
    '(delete-key-deletes-forward t)
    '(line-number-mode t)
    '(column-number-mode t)
    '(inhibit-startup-screen t)
    '(initial-scratch-message nil)
    '(initial-buffer-choice nil)
)

(setq default-tab-width 4)

;; Remove splash screen at startup.
(setq inhibit-splash-screen t)

;; Minimalistic interface.
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

(setq iswitchb-buffer-ignore '("*scratch*" "*Messages*"))

;; Haskell mode.
(load "/usr/share/emacs/site-lisp/haskell-mode/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)

;; Erlang mode.
(setq load-path (cons "/usr/lib/erlang/lib/tools-2.6.6.1/emacs" load-path))
(setq erlang-root-dir "/usr/lib/erlang")
(setq exec-path (cons "/usr/lib/erlang/bin" exec-path))
(require 'erlang-start)

;; PHP mode.
(load "/usr/share/emacs/site-lisp/php-mode.el")
(require 'php-mode)
;; CSS mode.
(autoload 'css-mode "css-mode")
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-mode))
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-indent-level '2)
;; MMM mode.
(require 'mmm-mode)
(setq mmm-global-mode 'maybe)
(mmm-add-group
    'fancy-html
    '(
        (html-php-tagged
            :submode php-mode
            :face mmm-code-submode-face
            :front "<[?]php"
            :back "[?]>")
        (html-css-attribute
            :submode css-mode
            :face mmm-declaration-submode-face
            :front "styleREMOVEME=\""
            :back "\"")))
;; The files to invoke the new HTML mode for.
(add-to-list 'auto-mode-alist '("\\.inc\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.php[34]?\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.[sj]?html?\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . html-mode))
;; The features that should be turned on in this HTML mode.
(add-to-list 'mmm-mode-ext-classes-alist '(html-mode nil html-js))
(add-to-list 'mmm-mode-ext-classes-alist '(html-mode nil embedded-css))
(add-to-list 'mmm-mode-ext-classes-alist '(html-mode nil fancy-html))

;; Color theme.
(require 'color-theme)
(color-theme-initialize)
(color-theme-charcoal-black)
;; Specific color theme for Haskell mode.
(defun haskell-mode-theme-hook ()
    (require 'color-theme)
    (color-theme-initialize)
    (color-theme-deep-blue))
(add-hook 'haskell-mode-hook 'haskell-mode-theme-hook)
;; Specific color theme for Erlang mode.
(defun erlang-mode-theme-hook ()
    (require 'color-theme)
    (color-theme-initialize)
    (color-theme-whateveryouwant))
(add-hook 'erlang-mode-hook 'erlang-mode-theme-hook)
;; Specific color theme for Java mode.
(defun java-mode-theme-hook ()
    (require 'color-theme)
    (color-theme-initialize)
    (color-theme-kingsajz))
(add-hook 'java-mode-hook 'java-mode-theme-hook)
;; Specific color theme for HTML mode.
(defun html-mode-theme-hook ()
    (require 'color-theme)
    (color-theme-initialize)
    (color-theme-dark-blue2))
(add-hook 'php-mode-hook 'html-mode-theme-hook)
(add-hook 'css-mode-hook 'html-mode-theme-hook)
(add-hook 'html-mode-hook 'html-mode-theme-hook)
(add-hook 'mms-mode-hook 'html-mode-theme-hook)
;; Specific color theme for Makefile mode.
(defun makefile-mode-theme-hook ()
    (require 'color-theme)
    (color-theme-initialize)
    (color-theme-subtle-blue))
(add-hook 'makefile-mode-hook 'makefile-mode-theme-hook)
