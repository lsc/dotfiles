;;; shrink-path-test.el --- tests for shrink-path.el -*- lexical-binding: t; -*-

;; Copyright (C) 2017 Benjamin Andresen

;; Author: Benjamin Andresen
;; Maintainer: Benjamin Andresen
;; Version: 0.0.1
;; Keywords: path
;; URL: http://github.com/shrink-path.el/shrink-path.el

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;; No commentary

;;; Code:
(require 'shrink-path)

(describe "shrink-path-dirs"
  (describe "using absolute path"
    (describe "home"
      (describe "path equals home"
        (it "trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "/home/test/"))
                  :to-equal
                  "~/"))
        (it "no trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "/home/test"))
                  :to-equal
                  "~/")))

      (describe "path equals home+1"
        (it "trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "/home/test/Projects/"))
                  :to-equal
                  "~/Projects/"))
        (it "no trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "/home/test/Projects"))
                  :to-equal
                  "~/Projects/"))
        (it "hidden"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "/home/test/.config/"))
                  :to-equal
                  "~/.config/")))

      (describe "path larger home+1"
        (it "no trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "/home/test/Projects/dotfiles"))
                  :to-equal
                  "~/P/dotfiles/"))
        (it "trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "/home/test/Projects/dotfiles/"))
                  :to-equal
                  "~/P/dotfiles/"))
        (it "last hidden"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "/home/test/Projects/dotfiles/.emacs.d"))
                  :to-equal
                  "~/P/d/.emacs.d/"))
        (it "middle hidden"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "/home/test/.config/mpv"))
                  :to-equal
                  "~/.c/mpv/"))))

    (describe "root"
      (it "root only"
        (expect (shrink-path-dirs "/") :to-equal "/"))
      (describe "root depth equals 1"
        (it "regular"
          (expect (shrink-path-dirs "/tmp") :to-equal "/tmp/"))
        (it "hidden"
          (expect (shrink-path-dirs "/.snapshotz") :to-equal "/.snapshotz/")))
      (describe "root depth larger than 1"
        (it "last regular"
          (expect (shrink-path-dirs "/etc/X11/xorg.conf.d")
                  :to-equal "/e/X/xorg.conf.d/"))
        (it "last hidden"
          (expect (shrink-path-dirs "/etc/openvpn/.certificates")
                  :to-equal "/e/o/.certificates/")))
      (it "middle hidden"
        (expect (shrink-path-dirs "/etc/openvpn/.certificates/london")
                :to-equal "/e/o/.c/london/"))))

  (describe "tilde path"
    (describe "home"
      (describe "path equals home"
        (it "trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "~/"))
                  :to-equal
                  "~/"))
        (it "no trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "~/"))
                  :to-equal
                  "~/")))
      (describe "path equals home+1"
        (it "trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "~/Projects/"))
                  :to-equal
                  "~/Projects/"))
        (it "no trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "~/Projects"))
                  :to-equal
                  "~/Projects/"))
        (it "hidden"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "~/.config/"))
                  :to-equal
                  "~/.config/")))

      (describe "path larger home+1"
        (it "no trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "~/Projects/dotfiles"))
                  :to-equal
                  "~/P/dotfiles/"))
        (it "trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "~/Projects/dotfiles/"))
                  :to-equal
                  "~/P/dotfiles/"))
        (it "last hidden"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "~/Projects/dotfiles/.emacs.d"))
                  :to-equal
                  "~/P/d/.emacs.d/"))
        (it "middle hidden"
          (expect (with-home "/home/test"
                    (shrink-path-dirs "~/.config/mpv"))
                  :to-equal
                  "~/.c/mpv/"))))))


(describe "shrink-path-prompt"
  (describe "using absolute path"
    (describe "home"
      (describe "path equals home"
        (it "trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "/home/test/"))
                  :to-equal
                  '("" . "~")))
        (it "no trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "/home/test"))
                  :to-equal
                  '("" . "~"))))

      (describe "path equals home+1"
        (it "trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "/home/test/Projects/"))
                  :to-equal
                  '("~/" . "Projects")))
        (it "no trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "/home/test/Projects"))
                  :to-equal
                  '("~/" . "Projects")))
        (it "hidden"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "/home/test/.config/"))
                  :to-equal
                  '("~/" . ".config"))))

      (describe "path larger home+1"
        (it "no trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "/home/test/Projects/dotfiles"))
                  :to-equal
                  '("~/P/" . "dotfiles")))
        (it "trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "/home/test/Projects/dotfiles/"))
                  :to-equal
                  '("~/P/" . "dotfiles")))
        (it "last hidden"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "/home/test/Projects/dotfiles/.emacs.d"))
                  :to-equal
                  '("~/P/d/" . ".emacs.d")))
        (it "middle hidden"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "/home/test/.config/mpv"))
                  :to-equal
                  '("~/.c/" . "mpv")))))

    (describe "root"
      (it "root only"
        (expect (shrink-path-prompt "/") :to-equal '("" . "/")))
      (describe "root depth equals 1"
        (it "regular"
          (expect (shrink-path-prompt "/tmp") :to-equal '("/" . "tmp")))
        (it "hidden"
          (expect (shrink-path-prompt "/.snapshotz") :to-equal '("/" . ".snapshotz"))))
      (describe "root depth larger than 1"
        (it "last regular"
          (expect (shrink-path-prompt "/etc/X11/xorg.conf.d")
                  :to-equal '("/e/X/" . "xorg.conf.d")))
        (it "last hidden"
          (expect (shrink-path-prompt "/etc/openvpn/.certificates")
                  :to-equal '("/e/o/" . ".certificates")))
        (it "middle hidden"
          (expect (shrink-path-prompt "/etc/openvpn/.certificates/london")
                  :to-equal '("/e/o/.c/" . "london"))))))


  (describe "tilde path"
    (describe "home"
      (describe "path equals home"
        (it "trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "~/"))
                  :to-equal
                  '("" . "~")))
        (it "no trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "~/"))
                  :to-equal
                  '("" . "~"))))

      (describe "path equals home+1"
        (it "trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "~/Projects/"))
                  :to-equal
                  '("~/" . "Projects")))
        (it "no trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "~/Projects"))
                  :to-equal
                  '("~/" . "Projects")))
        (it "hidden"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "~/.config/"))
                  :to-equal
                  '("~/" . ".config"))))

      (describe "path larger home+1"
        (it "no trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "~/Projects/dotfiles"))
                  :to-equal
                  '("~/P/" . "dotfiles")))
        (it "trailing slash"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "~/Projects/dotfiles/"))
                  :to-equal
                  '("~/P/" . "dotfiles")))
        (it "last hidden"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "~/Projects/dotfiles/.emacs.d"))
                  :to-equal
                  '("~/P/d/" . ".emacs.d")))
        (it "middle hidden"
          (expect (with-home "/home/test"
                    (shrink-path-prompt "~/.config/mpv"))
                  :to-equal
                  '("~/.c/" . "mpv")))))))

(describe "shrink-path-file-mixed"
  (describe "inside $HOME"
    (describe "shrink-path: single dir deep"
      (describe "relative path is"
        (it "child of shrink-path"
          (expect (shrink-path-file-mixed "/tmp"
                                          "/tmp/emacs1000"
                                          "/tmp/emacs1000/test.txt")
                  :to-equal
                  '("/" "tmp" "emacs1000" "test.txt")))
        (it "same as shrink-path"
          (expect (shrink-path-file-mixed "/tmp"
                                          "/tmp"
                                          "/tmp/volatile.log")
                  :to-equal
                  '("/" "tmp" nil "volatile.log")))))
    (describe "shrink-path: more than one dirs deep"
      (describe "relative path is"
        (it "child of shrink-path"
          (expect (shrink-path-file-mixed "~/Projects/Emacs-Lisp/shrink-path"
                                          "~/Projects/Emacs-Lisp/shrink-path/test"
                                          "~/Projects/Emacs-Lisp/shrink-path/test/shrink-path-test.el")
                  :to-equal
                  '("~/P/E/" "shrink-path" "test" "shrink-path-test.el")))
        (it "same as shrink-path"
          (expect (shrink-path-file-mixed "~/Projects/Emacs-Lisp/shrink-path"
                                          "~/Projects/Emacs-Lisp/shrink-path"
                                          "~/Projects/Emacs-Lisp/shrink-path/shrink-path.el")
                  :to-equal
                  '("~/P/E/" "shrink-path" nil "shrink-path.el"))))))
  (describe "outside $HOME"
    (describe "shrink-path: more than one dirs deep"
      (describe "relative path is"
        (it "same as shrink-path"
          (expect (shrink-path-file-mixed "/etc/modprobe.d/"
                                          "/etc/modprobe.d/"
                                          "/etc/modprobe.d/thinkpad_acpi.conf")
                  :to-equal '("/e/" "modprobe.d" nil "thinkpad_acpi.conf")))
        (it "child of shrink-path"
          (expect (shrink-path-file-mixed "/usr/share/emacs/"
                                          "/usr/share/emacs/26.0.50/lisp"
                                          "/usr/share/emacs/26.0.50/lisp/comint.el")
                  :to-equal '("/u/s/" "emacs" "26.0.50/lisp" "comint.el"))))))
  (describe "invalid input"
    (it "filename not descendant of relative-path"
      (expect (shrink-path-file-mixed "/tmp/"
                                      "/tmp/emacs1000/"
                                      "~/.emacs.d/init.el")
              :to-be nil))
    (it "relative-path not descendant of shrink-path"
      (expect (shrink-path-file-mixed "/tmp/"
                                      "~/.emacs.d/"
                                      "~/.emacs.d/init.el")
              :to-be nil))
    (it "relative-path and filename both not descendant of shrink-path"
      (expect (shrink-path-file-mixed "/tmp/"
                                      "~/.emacs.d/"
                                      "~/Projects/emacs-fun.el")
              :to-be nil)) ))

(provide 'shrink-path-test)
;;; shrink-path-test.el ends here
