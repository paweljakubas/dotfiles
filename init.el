;; TO-DO - major points
;; 0. Fill in TO-DOs below
;; 1. consul integration
;; 2. eglot things:
;; (a) haskell eglot
;; (b) lisp eglot
;; (c) rust eglot
;; (d) j eglot
;; (e) zig eglot
;; (f) julia eglot
;; 3. shell integration
;; 4. pdf/ebook reader

;;Abbrieviate y or n instead of yes or no
(fset 'yes-or-no-p 'y-or-n-p)

;;Show accompanying bracket
(show-paren-mode t)

;;Separate line number and the beginning of the line
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(global-set-key [f5] 'goto-line)

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
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq-default whitespace-line-column 80 whitespace-style '(face lines-tail))
(global-whitespace-mode)

(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
            '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; my first useful elisp function defined so needs to stay for historical reasons ;-)
(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

(global-set-key [C-f1] 'show-file-name)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(load-theme 'wombat t)

;; straight
;; Used for package downloading and compilation
;; every package store in .emacs.d/straight directory rather than .emacs.d/elpa directory
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq package-enable-at-startup nil)

;; treesitter
(setq treesit-language-source-alist
    '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (c "https://github.com/tree-sitter/tree-sitter-c")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (haskell "https://github.com/tree-sitter/tree-sitter-haskell")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (rust "https://github.com/tree-sitter/tree-sitter-rust")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(use-package treesit
  :when (and (fboundp 'treesit-available-p) (treesit-available-p))
  :custom
  (major-mode-remap-alist
   '((c-mode . c-ts-mode)
     (c++-mode . c++-ts-mode)
     (cmake-mode . cmake-ts-mode)
     (conf-toml-mode . toml-ts-mode)
     (css-mode . css-ts-mode)
     (haskell-mode . haskell-ts-mode)
     (js-mode . js-ts-mode)
     (js-json-mode . json-ts-mode)
     (json-mode . json-ts-mode)
     (python-mode . python-ts-mode)
     (sh-mode . bash-ts-mode)
     (typescript-mode . typescript-ts-mode))))

(use-package treesit-auto
  :straight t
  :ensure t
  :functions (treesit-auto-add-to-auto-mode-alist global-treesit-auto-mode)
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package tree-sitter-indent
  :straight t
  :ensure t)

;;(use-package flymake
;;  :straight t
;;  :ensure t
;;  :custom
;;  (flymake-no-changes-timeout 0.01)
;;  :hook (emacs-lisp-mode . flymake-mode)
;;  :bind (:map flymake-mode-map
;;              ("M-]" . flymake-goto-next-error)
;;              ("M-[" . flymake-goto-prev-error)
;;              ("M-\\" . flymake-show-buffer-diagnostics)))
;;

;; In order to enble this one needs to have https://github.com/ryanoasis/nerd-fonts fonts installed in the system.
;; M-x nerd-icons-install-fonts
(use-package nerd-icons
  :straight (nerd-icons
             :type git
             :host github
             :repo "rainstormstudio/nerd-icons.el"
             :files (:defaults "data"))
  :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  (nerd-icons-font-family "Symbols Nerd Font Mono"))

(use-package doom-modeline
  :straight t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

;; git tool
;; TO-DO add bindings C-c m X
(use-package magit
  :straight t
  :commands magit-get-top-dir
  :bind (("C-c g" . magit-status)
         ("C-c C-g l" . magit-file-log)
         ("C-c f" . magit-grep)))

;; Undo-redo tool
;; TO-DO add bindings C-c u X
(use-package undo-tree
    :straight t
    :init
    (global-undo-tree-mode 1))

(setq undo-tree-auto-save-history nil)

;; Language agnostic LSP client
;; Invoke M-x eglot in program-mode to use every time we start working in a project.
(use-package eglot
  :ensure t
  :bind (:map eglot-mode-map
	      ("C-c e a" . eglot-code-actions)
	      ("C-c e R" . eglot-rename)
	      ("C-c e h" . eldoc)
	      ("C-c e f" . eglot-format) ;; format the region, if no region selected then it defaults to eglot-format-buffer
	      ("C-c e F" . eglot-format-buffer)
	      ("C-c e d" . xref-find-definitions)
              ("C-c e i" . eglot-inlay-hints-mode) ;; switch on/off hint mode, by default it is switched on
              ("C-c e r" . xref-find-references)
	      ("C-c e c" . eglot-reconnect))
  :hook
  (bash-ts-mode . eglot-ensure)
  (js-ts-mode . eglot-ensure)
  :custom
  (eglot-autoshutdown t)
  (eglot-sync-connect 3)
  (eglot-confirm-server-initiated-edits nil)
  (eglot-events-buffer-size '(:size 2000 :format full))
  (eglot-send-changes-idle-time 0))

;; JS/TS
;; requires installing separately LSP server: typescript-language-server
;; https://github.com/typescript-language-server/typescript-language-server
(use-package js
  :straight t
  :after eglot
  :hook ((js-ts-mode . eglot-ensure)
         (js-ts-mode . (lambda ()
                         (eglot-inlay-hints-mode 1))))
  :mode (("\\.js\\'" . js-ts-mode)
         ("\\.jsx\\'" . js-ts-mode))
  :interpreter (("node" . js-ts-mode))
  :init (add-to-list 'eglot-server-programs
                     `((js-mode js-ts-mode tsx-ts-mode typescript-ts-mode typescript-mode) .
                       ("/home/pawel/.local/bin/typescript-language-server" "--stdio"
                        :initializationOptions (:preferences
                                                (:importModuleSpecifierPreference
                                                 "non-relative"
                                                 :includeInlayEnumMemberValueHints t
                                                 :includeInlayFunctionLikeReturnTypeHints t
                                                 :includeInlayFunctionParameterTypeHints t
                                                 :includeInlayParameterNameHints "all" ; "none" | "literals" | "all"
                                                 :includeInlayParameterNameHintsWhenArgumentMatchesName t
                                                 :includeInlayPropertyDeclarationTypeHints t
                                                 :includeInlayVariableTypeHints t
                                                 :includeInlayVariableTypeHintsWhenTypeMatchesName t
                                                 :organizeImportsCaseFirst "upper"
                                                 :organizeImportsCollation "unicode" ; "ordinal" | "unicode"
                                                 :organizeImportsIgnoreCase

                                                 :json-false
                                                 :quotePreference "single"))))))

;; Haskell
(defun haskell-eglot-setup ()
            "Setting up lsp server."
            (let* ((wrapper (executable-find "haskell-language-server-wrapper"))
                   (hls (or wrapper (executable-find "haskell-language-server")))
                   (modes '(haskell-mode haskell-literate-mode literate-haskell-mode haskell-debug-mode)))
              (cond
               (hls
                (let ((cmd (if wrapper
                             '("haskell-language-server-wrapper" "--lsp")
                             '("haskell-language-server" "--lsp"))))
                  (dolist (mm modes)
                    (setq-local eglot-server-programs
                                (cons (cons mm cmd)
                                      (assq-delete-all mm eglot-server-programs))))))
               (t))))

(defun haskell-eglot-ensure ()
            "Eglot in Haskell buffer, only when server is available and set-up."
            (let* ((hls (or (executable-find "haskell-language-server-wrapper")
                            (executable-find "haskell-language-server"))))
              (if (or hls)
                  (eglot-ensure)
                      (message "HLS not in PATH"))))

(use-package haskell-mode
  :straight t
  :after eglot
  :defer t
  :init
  (add-to-list 'eglot-server-programs
               '(haskell-mode . ("haskell-language-server-wrapper" "--lsp")))
  (add-to-list 'eglot-server-programs
               '(haskell-literate-mode . ("haskell-language-server-wrapper" "--lsp")))
  (add-to-list 'eglot-server-programs
               '(literate-haskell-mode . ("haskell-language-server-wrapper" "--lsp")))
  (add-to-list 'eglot-server-programs
               '(haskell-debug-mode . ("haskell-language-server-wrapper" "--lsp")))
  :hook ((haskell-mode . haskell-eglot-setup)
         (haskell-mode . haskell-eglot-ensure)
         (haskell-mode . haskell-decl-scan-mode)
         (haskell-mode . haskell-doc-mode)
         (haskell-mode . interactive-haskell-mode)
         (haskell-mode . yas-minor-mode))
  :custom
  (haskell-indentation-layout-offset 4)
  (haskell-indentation-left-offset 4)
  ;; ormolu
  (haskell-stylish-on-save nil)
  :bind
  (:map haskell-mode-map
        ("C-c C-l" . haskell-process-load-file)
        ("C-c C-t" . haskell-mode-show-type-at)
        ("C-c C-i" . haskell-process-do-info)))
