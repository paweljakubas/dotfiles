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

;; package installation
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (progn
        (package-refresh-contents)
        (package-install 'use-package)))
(require 'use-package)

(require 'bind-key)

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

(use-package magit
  :ensure t
  :commands magit-get-top-dir
  :bind (("C-c g" . magit-status)
         ("C-c C-g l" . magit-file-log)
         ("C-c f" . magit-grep)))

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

;; Haskell stuff
(setenv "PATH"
        (concat (getenv "HOME") "/.local/bin:"
                (getenv "HOME") "/.cabal/bin:"
                (getenv "HOME") "/.ghcup/bin:"
                "/usr/local/bin:"
                (getenv "PATH")))

(setq exec-path
      (reverse
       (append
        (reverse exec-path)
        (list (concat (getenv "HOME") "/.local/bin")
              (concat (getenv "HOME") "/.cabal/bin")
              (concat (getenv "HOME") "/.ghcup/bin")
              "/usr/local/bin" ))))

;;LSP Haskell
;;
;; (a) generate hie.yaml for project
;; cd project
;; stack install implicit-hie
;; gen-hie > hie.yaml
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

(use-package yasnippet
  :ensure t)

;; from https://blog.sumtypeofway.com/posts/emacs-config.html
(use-package haskell-mode
  :init
  (add-hook 'before-save-hook #'lsp-format-buffer)
  :config
  ;; haskell-mode doesn't know about newer GHC features.
  (let ((new-extensions '("QuantifiedConstraints"
                          "DerivingVia"
                          "BlockArguments"
                          "DerivingStrategies"
                          "StandaloneKindSignatures"
                          )))
    (setq
     haskell-ghc-supported-extensions
     (append haskell-ghc-supported-extensions new-extensions))))

(use-package haskell-snippets
  :after (haskell-mode yasnippet)
  :defer)

(use-package lsp-mode
  :ensure t
  ;; we need to defer running lsp because in case there's a direnv
  ;; with use nix, it takes some time to load and lsp won't find the
  ;; language server until the env is setup properly
  :hook ((haskell-mode . lsp-deferred))
  :commands (lsp lsp-deferred))

(use-package lsp-haskell
  :ensure t
  :custom
  (lsp-haskell-stylish-haskell-on 't)
  (lsp-haskell-formatting-provider "stylish-haskell"))

(setq lsp-log-io 't)

(use-package lsp-ui :commands lsp-ui-mode)
