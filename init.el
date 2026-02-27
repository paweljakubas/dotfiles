;; init.el --- The initial emacs configuration -*- lexical-binding: t -*-

;; TO-DO - major points
;; 0. Fill in TO-DOs below
;; 2. eglot things:
;; (b) lisp eglot
;; (c) rust eglot
;; (d) j eglot
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
;;(add-hook 'before-save-hook 'whitespace-cleanup)
;;(add-hook 'before-save-hook (lambda()  (delete-trailing-whitespace)))

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

(setq-default ispell-program-name "aspell")
(add-hook 'text-mode-hook 'flyspell-mode)

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
;; install language grammer via
;;   M-x treesit-install-language-grammar LANG
(setq treesit-language-source-alist
    '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(use-package treesit
  :when (and (fboundp 'treesit-available-p) (treesit-available-p))
  :custom
  (major-mode-remap-alist
   '((css-mode . css-ts-mode)
     (js-mode . js-ts-mode)
     (js-json-mode . json-ts-mode)
     (json-mode . json-ts-mode)
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
  :custom ((doom-modeline-height 25)
           (doom-modeline-max-length 35)))

(use-package rainbow-delimiters
  :straight t  
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package multiple-cursors
  :straight t
  :bind (("C-c c r" . mc/edit-lines)
         ("C-c c n" . mc/mark-next-like-this)
         ("C-c c p" . mc/mark-previous-like-this)
         ("C-c c a" . mc/mark-all-like-this)))

(use-package ivy
  :straight t
  :ensure t  
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package which-key
  :straight t
  :ensure t  
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package ivy-rich
  :straight t
  :ensure t
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :straight t
  :ensure t  
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; git tool
(use-package magit
  :straight t
  :commands magit-get-top-dir
  :bind (("C-c m g" . magit-status)
         ("C-c m l" . magit-file-log)
         ("C-c m f" . magit-grep)))

;; Undo-redo tool
;; TO-DO add bindings C-c u X
(use-package undo-tree
    :straight t
    :init
    (global-undo-tree-mode 1))

(setq undo-tree-auto-save-history nil)

;; Add ghcup to PATH (auto-detect GHC and HLS versions) plus define home dir
(let* ((home-dir (or (getenv "HOME") (expand-file-name "~")))
       (ghc-dir (car (directory-files (concat home-dir "/.ghcup/ghc") t "^9\\.")))
       (ghc-ver (and ghc-dir (file-name-nondirectory ghc-dir)))
       (hls-dir (car (sort (directory-files (concat home-dir "/.ghcup/hls") t) (lambda (a b) (string< b a)))))
       (hls-ver (and (not (string-match "^\\." hls-dir)) (file-name-nondirectory hls-dir))))
  (when ghc-ver
    (setenv "PATH" (concat home-dir "/.ghcup/bin:" home-dir "/.ghcup/ghc/" ghc-ver "/bin:" (getenv "PATH")))
    (push (concat home-dir "/.ghcup/bin") exec-path)
    (push (concat home-dir "/.ghcup/ghc/" ghc-ver "/bin") exec-path))
  (setq haskell-language-server-wrapper (if hls-ver
    (concat "haskell-language-server-wrapper-" hls-ver)
    "haskell-language-server-wrapper"))
)

;; Language agnostic LSP client
;; Invoking M-x eglot in program-mode to use every time we start working in a project.
(use-package eglot
  :straight t  
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
  (haskell-mode . eglot-ensure)
  (zig-mode-hook . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs `(haskell-mode . (,haskell-language-server-wrapper "--lsp")))
  :custom
  (eglot-autoshutdown t)
  (eglot-sync-connect 3)
  (eglot-confirm-server-initiated-edits nil)
  (eglot-events-buffer-size '(:size 2000 :format full))
  (eglot-send-changes-idle-time 0))

(use-package company
  :straight t
  :after eglot
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0)
  (add-to-list 'company-backends 'company-capf))

;; JS/TS
;; requires installing separately LSP server: typescript-language-server
;; https://github.com/typescript-language-server/typescript-language-server
(use-package js
  :straight t
  :after eglot
  :defer t
  :hook ((js-ts-mode . eglot-ensure)
         (js-ts-mode . (lambda ()
                         (eglot-inlay-hints-mode 1))))
  :mode (("\\.js\\'" . js-ts-mode)
         ("\\.jsx\\'" . js-ts-mode))
  :interpreter (("node" . js-ts-mode))
  :init (add-to-list 'eglot-server-programs
                     `((js-mode js-ts-mode tsx-ts-mode typescript-ts-mode typescript-mode) .
                        ((concat (or (getenv "HOME") (expand-file-name "~")) "/.local/bin/typescript-language-server") "--stdio"
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


;; Zig
;; requires installing separately ZLS: zig-language-server
;; via debian apt
(use-package zig-mode
  :straight t
  :after eglot
  :defer t
  :init (add-to-list 'eglot-server-programs
    '(zig-mode . (
      ;; Use `zls` if it is in your PATH
      "/usr/bin/zls"
      ;; There are two ways to set config options:
      ;;   - edit your `zls.json` that applies to any editor that uses ZLS
      ;;   - set in-editor config options with the `initializationOptions` field below.
      ;;
      ;; Further information on how to configure ZLS:
      ;; https://zigtools.org/zls/configure/
      :initializationOptions
        (;; Whether to enable build-on-save diagnostics
         ;;
         ;; Further information about build-on save:
         ;; https://zigtools.org/zls/guides/build-on-save/
         ;;enable_build_on_save t
         )))))

;; Haskell

;;Create symlinks in ~/.ghcup/bin if missing:
;;```bash
;;ln -s ../ghc/9.10.3/bin/ghc ~/.ghcup/bin/ghc
;;ln -s ../ghc/9.10.3/bin/ghc-pkg ~/.ghcup/bin/ghc-pkg
;;```

;; requires installing separately LSP server: haskell-language-server
;; setup via ghcup tool
(use-package haskell-mode
  :straight t
  :after eglot
  :defer t
  :init (add-to-list 'eglot-server-programs
                     `((haskell-mode haskell-ts-mode haskell-literate-mode literate-haskell-mode haskell-debug-mode) .
                         (,haskell-language-server-wrapper "--lsp")))
  :hook ((haskell-mode . haskell-decl-scan-mode)
         (haskell-mode . haskell-doc-mode)
         (haskell-mode . eldoc-mode)
         (haskell-mode . interactive-haskell-mode))
  :mode (("\\.hs\\'" . haskell-mode)
         ("\\.lhs\\'" . haskell-mode))
  :custom
  (haskell-indentation-layout-offset 4)
  (haskell-indentation-left-offset 4)
  (haskell-stylish-on-save nil)
  :bind
  (:map haskell-mode-map
        ("C-c C-l" . haskell-process-load-file)
        ("C-c C-t" . haskell-mode-show-type-at)
        ("C-c C-i" . haskell-process-do-info)))

;; part of haskell-mode package
(use-package haskell-interactive-mode
  :defer t
  :requires haskell-mode
  :custom
  (haskell-process-type 'cabal-repl)
  (haskell-process-auto-import-loaded-modules t)
  (haskell-process-log t)
  :bind
  (:map haskell-mode-map
        ("C-c C-z" . haskell-interactive-switch)
        ("C-c C-k" . haskell-interactive-mode-clear)))

;; part of haskell-mode package
(use-package haskell-doc
  :defer t
  :requires haskell-mode
  :config (haskell-doc-mode t))

