;;; modules/doom/packages.el -*- lexical-binding: t; no-byte-compile: t; -*-

;; doom.el
(package! compat
  :recipe (:host github :repo "emacs-compat/compat")
  :pin "b5b48183689b536f72b1214106afeabc465da9d4")  ; 31.0.0.1
(unless (fboundp 'igc-info)
  (package! gcmh
    :pin "0089f9c3a6d4e9a310d0791cf6fa8f35642ecfd9"))

;; doom-packages.el
(package! straight
  :type 'core
  :recipe `(:host github
            :repo "radian-software/straight.el"
            :branch "develop"
            :local-repo "straight.el"
            :files ("straight*.el"))
  :pin "e40a5b7f8b0c1bb2cde0e7e477b5f81303e34b95")

;; doom-ui.el
(package! nerd-icons :pin "d7742c5e8fba5d601633dd46f4cd7b34928f1185")

;; doom-projects.el
(package! project :pin "883c035af5b66550a1692b89bb11a9daead62d61")

;; doom-keybinds.el
(package! which-key
  :recipe (:host github :repo "emacs-straight/which-key")
  :pin "78bf634e98ff989df3d86bceffe99b3278e32b12"
  :built-in 'prefer)
