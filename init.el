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
;;(setq-default tab-width 4)
;;(setq indent-line-function 'insert-tab)
;;(customize-variable (quote tab-stop-list))
;;(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 ;;'(tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))))

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

;;Set 80-wide vertical line
;;(setq-default header-line-format
;;      (list " " (make-string 79 ?~) "|"))
(setq-default whitespace-line-column 80 whitespace-style '(face lines-tail))
(global-whitespace-mode)

(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
            '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

(global-set-key [C-f1] 'show-file-name)

;;Set package sources
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (progn
        (package-refresh-contents)
        (package-install 'use-package)))
(require 'use-package)
(require 'bind-key)
(setq package-check-signature nil)

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
   '(haskell-interactive-popup-errors nil)
   ;; Customization related to indentation.
   '(haskell-indentation-layout-offset 4)
   '(haskell-indentation-starter-offset 4)
   '(haskell-indentation-left-offset 4)
   '(haskell-indentation-where-pre-offset 4)
   '(haskell-indentation-where-post-offset 4)
   )

  (add-hook 'haskell-mode-hook 'haskell-indentation-mode)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (add-hook 'haskell-mode-hook 'flycheck-mode)
  (add-hook 'before-save-hook 'haskell-mode-format-imports nil t)
  ; (add-hook 'haskell-mode-hook 'ghc-init)
  (define-key haskell-mode-map (kbd "M-,") (function xref-pop-marker-stack))
)

(use-package elm-mode
  :ensure t
  :mode "\\.elm\\'"
  :init
  (add-to-list 'company-backends 'company-elm)
)


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
 '(haskell-indentation-layout-offset 4)
 '(haskell-indentation-left-offset 4)
 '(haskell-indentation-starter-offset 4)
 '(haskell-indentation-where-post-offset 4)
 '(haskell-indentation-where-pre-offset 4)
 '(haskell-interactive-popup-errors nil)
 '(haskell-process-type (quote stack-ghci))
 '(haskell-stylish-on-save t)
 '(package-selected-packages
   (quote
    (wordnut markdown-mode elm-mode zenburn-theme web-mode use-package tss scss-mode scala-mode2 rainbow-mode neotree magit less-css-mode julia-mode jsx-mode js2-refactor js-doc intero ghc ggtags flycheck-haskell epc ensime company-tern color-theme-wombat badger-theme ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package wordnut
  :ensure t )

(global-set-key [f12] 'wordnut-search)
(global-set-key [C-f12] 'wordnut-lookup-current-word)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))
