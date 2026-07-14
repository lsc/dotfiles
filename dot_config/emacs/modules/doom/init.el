;;; modules/doom/init.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;;
;;; * Extra file extensions to support

(add-to-list 'auto-mode-alist '("/LICENSE\\'" . text-mode))
(add-to-list 'auto-mode-alist '("rc\\'" . conf-mode) 'append)

;; Support for Doom dotfiles
(add-to-list 'auto-mode-alist '("/\\.doom\\(?:modules?\\|profiles?\\)?\\'" . lisp-data-mode))


;;
;;; * 3rd Party Packages

;; The GC introduces annoying pauses and stuttering into our Emacs experience,
;; so we use `gcmh' to stave off the GC while we're using Emacs, and provoke it
;; when it's idle. However, if the idle delay is too long, we run the risk of
;; runaway memory usage in busy sessions. And if it's too low, then we may as
;; well not be using gcmh at all.
(use-package! gcmh-mode
  :unless (fboundp 'igc-info)
  :hook (doom-first-buffer . gcmh-mode)
  :config
  (setq gcmh-idle-delay 'auto  ; default is 15s
        gcmh-auto-idle-delay-factor 10
        gcmh-high-cons-threshold (* 64 1024 1024))) ; 64mb


(use-package! nerd-icons
  :commands (nerd-icons-octicon
             nerd-icons-faicon
             nerd-icons-flicon
             nerd-icons-wicon
             nerd-icons-mdicon
             nerd-icons-codicon
             nerd-icons-devicon
             nerd-icons-ipsicon
             nerd-icons-pomicon
             nerd-icons-powerline))

;;; init.el ends here
