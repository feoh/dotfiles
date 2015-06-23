(add-to-list 'default-frame-alist '(font . "Menlo:pixelsize=24:weight=normal:slant=normal:width=normal:spacing=100:scalable=true" ))

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



