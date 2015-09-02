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
(require 'diminish)
(require 'bind-key)

;;Packages
(use-package diminish
    :ensure t)

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

;; (use-package jedi
;;   :preface
;;   (declare-function jedi:goto-definition jedi nil)
;;   (declare-function jedi:related-names jedi nil)
;;   (declare-function jedi:show-doc jedi nil)
;;   :bind (("C-." . jedi:goto-definition)
;;	 ("C-c r" . jedi:related-names)
;;	 ("C-?" . jedi:show-doc)))

;; (use-package python
;;   :ensure pungi
;;   :bind (("<f3>" . py-insert-debug)
;;	 ("<f9>" . py-insert-debug))
;;   :mode (("\\.py$" . python-mode)
;;	 ("\\.cpy$" . python-mode)
;;	 ("\\.vpy$" . python-mode))
;;   :config
;;   (declare-function py-insert-debug netsight nil)
;;   (setq fill-column 79)
;;   (setq-default flycheck-flake8rc "~/.config/flake8rc")
;;   (setq python-check-command "flake8")
;;   (setq tab-width 4)
;;   (pungi:setup-jedi)
;;   (sphinx-doc-mode t))

;; (use-package sphinx-doc)

;; (use-package company-jedi
;;   :config
;;   (defun my/python-mode-hook ()
;;	(add-to-list 'company-backends 'company-jedi))
;;   (add-hook 'python-mode-hook 'my/python-mode-hook))

;; (use-package pyvenv)

(use-package deferred
  :ensure t)

(use-package graphviz-dot-mode
  :ensure t)

(use-package scala-mode2
		 :ensure
		 :defer t
		 :init
		 (progn
		   (use-package ensime
				:ensure)
		   (use-package sbt-mode
		     :ensure))
		 :config
		 (add-hook 'scala-mode-hook 'ensime-scala-mode-hook))

(use-package yasnippet
		 :diminish yas-minor-mode
		 :defer t
		 :ensure t
		 :mode ("/\\.emacs\\.d/snippets/yasnippet-snippets/" . snippet-mode)
		 :init
		 (progn
		 (setq yas-verbosity 3))
		 (yas-global-mode 1))

;; GNU Global Tags
(use-package ggtags
  :demand t
  :init
  (define-globalized-minor-mode global-ggtags-mode ggtags-mode
    (lambda ()
       (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
	 (ggtags-mode 1)))))

(use-package company
  :defer 5
  :config (progn
	    (setq company-idle-delay 0.25)
	    (add-hook 'c++-mode-hook
		      #'(lambda ()
			  (make-local-variable 'company-clang-arguments)
			  (setq company-clang-arguments '("-std=c++1y"))))
	    (setq company-backends '(company-bbdb
				     company-nxml
				     company-css
				     company-eclim
				     company-semantic
				     ;; company-clang
				     company-xcode
				     company-cmake
				     company-capf
				     (company-gtags
				      company-etags
				      :with
				      company-keywords
				      company-dabbrev-code)
				     company-clang ; moved down
				     company-oddmuse
				     company-files
				     company-dabbrev))
	    (add-hook 'eshell-mode-hook '(lambda ()
					   (company-mode 0)))
	    (add-hook 'org-mode-hook '(lambda ()
					(company-mode 0)))
	    (global-company-mode 1))
  :init (use-package company-clang
	  :bind ("C-c V" . company-clang))
  :bind ("C-c v" . company-complete)
  :demand t)

;; Auto-complete
;; (use-package auto-complete
;;   :ensure t
;;   :disabled t
;;   :config
;;   ;; add to dictionary directories
;;   ;;(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
;;   ;; default configuration for auto-complete
;;   (require 'auto-complete-config)
;;   (ac-config-default)
;;   ;; include C headers
;;   (defun my:ac-c-header-init ()
;;	(require 'auto-complete-c-headers)
;;	(add-to-list 'ac-sources 'ac-source-c-headers)
;;	(add-to-list 'achead:include-directories '"/usr/include"))
;;   ;; call this function from c/c++ hooks
;;   (add-hook 'c++-mode-hook 'my:ac-c-header-init)
;;   (add-hook 'c-mode-hook 'my:ac-c-header-init))

;; ;; (use-package c-c++-header)
;; ;;   :mode ("\\.h\\'" . c-c++-header)
;; ;;   :init (defalias 'h++-mode 'c++-mode))



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("9b402e9e8f62024b2e7f516465b63a4927028a7055392290600b776e4a5b9905" "a444b2e10bedc64e4c7f312a737271f9a2f2542c67caa13b04d525196562bf38" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
