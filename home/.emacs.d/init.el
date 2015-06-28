(add-to-list 'default-frame-alist '(font . "Menlo:pixelsize=24:weight=normal:slant=normal:width=normal:spacing=100:scalable=true" ))

;; Add all the groovy locally installed packages to emacs exec path
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
     package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
              package-archives)

(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file t)

(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)
(server-start)

(require 'twittering-mode)

(setq twittering-use-master-password t)

(setq magit-last-seen-setup-instructions "1.4.0")

(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)

(require 'helm-config)

(add-to-list 'load-path "~/.emacs.d/elisp/")

(add-hook 'python-mode-hook 'anaconda-mode)


