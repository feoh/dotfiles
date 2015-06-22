(defun save-package-list ()
  "Save the list of installed packages to a file."
  (with-temp-file "~/Dropbox/.emacs-packages-installed.el" (insert (format "(defvar my-packages '%s)" package-activated-list))))
  
(add-hook 'kill-emacs-hook 'save-package-list)

(load-file "~/Dropbox/.emacs-packages-installed.el")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))