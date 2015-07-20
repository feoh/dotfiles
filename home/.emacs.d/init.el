;; Personal emacs setup

(add-to-list 'default-frame-alist '(font . "Menlo:pixelsize=24:weight=normal:slant=normal:width=normal:spacing=100:scalable=true" ))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; OSX key bindings
(when (eq system-type 'darwin) ;; mac specific settings
  (require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta)
  (global-set-key [kp-delete] 'delete-char) ;; sets fn-delete to be right-delete
  )
(when (eq system-type 'gnu/linux)
  (require 'cask "~/.cask/cask.el")
  )

;; Make the mouse-wheel support not do insane things with the OSX trackpad :)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

(setenv "EDITOR" "emacsclient")
(setenv "VISUAL" "emacsclient")

(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
     package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
              package-archives)

(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file t)


(cask-initialize)
(require 'pallet)
(pallet-mode t)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(server-start)

(require 'twittering-mode)

(setq twittering-use-master-password t)

(setq magit-last-seen-setup-instructions "1.4.0")

(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)

(require 'helm-config)

(add-to-list 'load-path "~/.emacs.d/elisp/")



;; Company configs
(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 1)
(setq company-auto-complete nil)
(setq company-minimum-prefix-length 0)

(setq-default tab-always-indent 'complete)
(setq indent-line-function 'indent-for-tab-command)

;; Robe mode for Ruby
(add-hook 'ruby-mode-hook 'robe-mode)

(eval-after-load 'company
  '(push 'company-robe company-backends))

;; Anaconda mode for Python
(add-hook 'python-mode-hook 'anaconda-mode)

;; Syntax checking good! :)
(add-hook 'after-init-hook #'global-flycheck-mode)
