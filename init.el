(setq user-full-name "Pawel Jakubas")
(setq user-mail-address "jakubas.pawel@gmail.com")

;;Abbrieviate y or n instead of yes or no
(fset 'yes-or-no-p 'y-or-n-p)

;;Show accompanying bracket
(show-paren-mode t)

;;Show line numbers
(global-linum-mode 1)
;;Separate line number and the beginning of the line
(setq linum-format "%d ")
(global-set-key [f4] 'goto-line)

;;Highligth trailing white spaces
(setq-default show-trailing-whitespace t)

;;Tabs to Spaces
(setq-default indent-tabs-mode nil)

;;If there are trailing spaces remove them before saving the file
(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'before-save-hook (lambda()  (delete-trailing-whitespace)))

;;Removing backup files
(setq make-backup-files nil)
(setq backup-inhibited t)
(setq auto-save-default nil)

;;Set locale to UTF8
(set-language-environment 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;Set package sources
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (progn
        (package-refresh-contents)
        (package-install 'use-package)))
(require 'use-package)
(require 'bind-key)

;;Packages
(use-package neotree
    :ensure t
    :bind ([f2] . neotree-toggle)
    :config
      (define-key neotree-mode-map (kbd "i") #'neotree-enter-horizontal-split)
      (define-key neotree-mode-map (kbd "l") #'neotree-enter-vertical-split))

;;My preffered color themes
;; (use-package zenburn-theme
;;     :ensure t
;;     :config
;;        (add-hook 'after-init-hook '(lambda () (interactive) (load-theme 'zenburn)))
;;        (setq frame-background-mode 'dark))

;;(use-package badger-theme
;;    :ensure t
;;    :config
;;       (add-hook 'after-init-hook '(lambda () (interactive) (load-theme 'badger))))

(use-package color-theme-wombat
        :ensure t
        :config
           (add-hook 'after-init-hook '(lambda () (interactive) (load-theme 'wombat)))
           (setq frame-background-mode 'dark))

(use-package deferred
  :ensure t)


(use-package scala-mode2
                 :ensure t
                 :defer t
                 :init
                 (progn
                   (use-package ensime
                                :ensure)
                   (use-package sbt-mode
                     :ensure))
                 :config
                 (add-hook 'scala-mode-hook 'ensime-scala-mode-hook))

(use-package web-mode
  :ensure t
  :defer t
  :init
  (add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
 )

(use-package flycheck
  :ensure t
  :init
  (setq flycheck-highlighting-mode 'nil)
  (add-hook 'after-init-hook #'global-flycheck-mode)
  :config
;; disable jshint since we prefer eslint checking
  (setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(javascript-jshint)))

;; use eslint with web-mode for jsx files
  (flycheck-add-mode 'javascript-eslint 'web-mode)

;; customize flycheck temp file prefix
  (setq-default flycheck-temp-prefix ".flycheck")

;; disable json-jsonlist checking for json files
  (setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                          '(json-jsonlist))))

(use-package company
  :ensure t
  :diminish company-mode
  :init
  (setq company-dabbrev-ignore-case t
        company-dabbrev-downcase nil)
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (use-package company-tern
    :ensure t
    :init (add-to-list 'company-backends 'company-tern)))

(use-package yasnippet
  :disabled t
  :ensure t
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

(use-package ag
  :ensure t)

(use-package json-mode
  :ensure t
  :init (setq js-indent-level 2))

(use-package magit
  :ensure t
  :commands magit-get-top-dir
  :bind (("C-c g" . magit-status)
         ("C-c C-g l" . magit-file-log)
         ("C-c f" . magit-grep)))

(use-package ghc
  :ensure t
  :commands ghc-init ghc-debug)

(use-package flycheck-haskell
  :ensure t
  :commands flycheck-haskell-setup)

;;(eval-after-load 'flycheck
;;'(require 'flycheck-hdevtools))

(use-package haskell-mode
  :ensure t
  :mode "\\.hs\\'"
  :commands haskell-mode
  :bind ("C-c C-s" . fix-imports)
  :config
  (custom-set-variables
   '(haskell-stylish-on-save t)
   '(haskell-ask-also-kill-buffers nil)
   '(haskell-process-type (quote stack-ghci))
   '(haskell-interactive-popup-errors nil))

  (add-hook 'haskell-mode-hook 'haskell-indentation-mode)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (add-hook 'haskell-mode-hook 'flycheck-mode)
  (add-hook 'before-save-hook 'haskell-mode-format-imports nil t)
  ; (add-hook 'haskell-mode-hook 'ghc-init)
)

(use-package elm-mode
  :ensure t
  :mode "\\.elm\\'"
  :init
  (add-to-list 'company-backends 'company-elm)
)


;;(use-package js2-mode
;;  :ensure t
;;  :mode "\\.js\\'"
;;  :init
;;  (setq js2-highlight-level 3
;;        js2-basic-offset 2
;;        js2-allow-rhino-new-expr-initializer nil
;;        js2-global-externs '("describe" "before" "beforeEach" "after" "afterEach" "it")
;;        js2-include-node-externs t)
;;  (add-hook 'js2-mode-hook (lambda ()
;;                             (subword-mode 1)
;;                             (diminish 'subword-mode)))
;;  (add-hook 'js2-mode-hook 'js2-imenu-extras-mode)
;;  (rename-modeline "js2-mode" js2-mode "JS2")
;;  :config
;;  (use-package tern
;;    :ensure t
;;    :diminish tern-mode
;;    :init
;;    (add-hook 'js2-mode-hook 'tern-mode))
;;  (use-package js-doc
;;    :ensure t)
;;  (use-package js2-refactor
;;    :ensure t
;;    :diminish js2-refactor-mode
;;   :init
;;    (add-hook 'js2-mode-hook #'js2-refactor-mode)
;;    :config
;;        (js2r-add-keybindings-with-prefix "C-c r")))

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.ejs\\'" . web-mode)
         ("\\.jsx\\'" . web-mode))
  :init
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-style-padding 2
        web-mode-script-padding 2)

  (defun my-setup-web-mode-html ()
    (message "== setup web-mode for HTML ==")
    (local-set-key (kbd "C-=") 'web-mode-mark-and-expand)
    (flycheck-disable-checker 'javascript-eslint)
    (flycheck-select-checker 'html-tidy))

  (defun my-setup-web-mode-jsx ()
    (message "== setup web-mode for JSX ==")
    (local-set-key (kbd "C-=") 'er/expand-region)
    ;; TODO: Somehow the html-tidy checker is still enabled when a jsx
    ;; file is opened, but the errors disappear after the first
    ;; change. Investigate further.
    (flycheck-disable-checker 'html-tidy)
    (flycheck-select-checker 'javascript-eslint)
    (tern-mode 1)
    (diminish 'tern-mode))

  (defun my-setup-web-mode ()
    (if (equal (file-name-extension buffer-file-name) "jsx")
        (my-setup-web-mode-jsx)
      (my-setup-web-mode-html)))

  (defun my-web-mode-hook ()
    (setq-local electric-pair-pairs (append electric-pair-pairs '((?' . ?'))))
    (setq-local electric-pair-text-pairs electric-pair-pairs))

  ;; (defadvice switch-to-buffer (after my-select-web-mode-config activate)
  ;;   (when (equal major-mode 'web-mode)
  ;;       (my-setup-web-mode)))

  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (flycheck-add-mode 'html-tidy 'web-mode)

  (add-hook 'web-mode-hook 'my-web-mode-hook))

(use-package jsx-mode
  :ensure t
  :init (setq jsx-indent-level 2))

(use-package tss
  :ensure t
  :mode ("\\.ts\\'" . typescript-mode))

(use-package css-mode
  :init (setq css-indent-offset 2)
  :config
  (use-package rainbow-mode
    :ensure t
    :diminish rainbow-mode
    :init
    (add-hook 'css-mode-hook (lambda () (rainbow-mode t)))))

(use-package less-css-mode
  :ensure t)

(use-package elpy
  :ensure t
  :init (elpy-enable))

(use-package scss-mode
  :ensure t
  :mode (("\\.scss\\'" . scss-mode)
                  ("\\.postcss\\'" . scss-mode)))


(add-to-list 'load-path "/home/pawel/.emacs.d/ess/ESS/lisp/")
(load "ess-site")
(setq ess-history-directory "~/R/")

(use-package intero
  :ensure t
  :init (add-hook 'haskell-mode-hook 'intero-mode))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(haskell-ask-also-kill-buffers nil)
 '(haskell-interactive-popup-errors nil)
 '(haskell-process-type (quote stack-ghci))
 '(package-selected-packages
   (quote
    (elm-mode zenburn-theme web-mode use-package tss scss-mode scala-mode2 rainbow-mode neotree magit less-css-mode julia-mode jsx-mode js2-refactor js-doc intero ghc ggtags flycheck-haskell epc ensime company-tern color-theme-wombat badger-theme ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
