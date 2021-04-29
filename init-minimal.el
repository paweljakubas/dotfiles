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

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;;Set package sources
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
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
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package neotree
    :ensure t
    :bind ([f2] . neotree-toggle)
    :config
      (define-key neotree-mode-map (kbd "i") #'neotree-enter-horizontal-split)
      (define-key neotree-mode-map (kbd "l") #'neotree-enter-vertical-split)
      (setq neo-smart-open t))

(use-package color-theme-modern
        :ensure t
        :config
           (add-hook 'after-init-hook '(lambda () (interactive) (load-theme 'wombat)))
           (setq frame-background-mode 'dark))

(use-package deferred
  :ensure t)

(use-package vdiff
  :load-path "/usr/bin/vdiff"
  :commands (vdiff-buffers vdiff-files)
  :config
  (define-key vdiff-mode-map (kbd "C-c") vdiff-mode-prefix-map))

(use-package company
    :ensure t
    :diminish company-mode
    :defines
      (company-dabbrev-ignore-case company-dabbrev-downcase)
    :hook
      (after-init . global-company-mode)
    :config
      ;after how many letters do we want to get completion tips? 1 means from the first letter
      (setq company-minimum-prefix-length 1)
      (setq company-dabbrev-downcase 0)
      ;after how long of no keys should we get the completion tips? in seconds
      (setq company-idle-delay 0.4))

;shortcut for completion
(global-set-key (kbd "C-c w") 'company-complete)

(use-package flycheck
    :ensure t
    :bind ([f9] . flycheck-list-errors)
    :init
      (setq flycheck-highlighting-mode 'nil)
      (add-hook 'after-init-hook #'global-flycheck-mode)
    :config
      (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
      (setq-default flycheck-temp-prefix ".flycheck"))

(use-package magit
  :ensure t
  :commands magit-get-top-dir
  :bind (("C-c g" . magit-status)
         ("C-c C-g l" . magit-file-log)
         ("C-c f" . magit-grep)))

(use-package flycheck-haskell
  :ensure t
  :commands flycheck-haskell-setup)

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
