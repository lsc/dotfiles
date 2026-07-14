;;; test-helper.el --- description -*- lexical-binding: t; -*-

;; only eval non-interactively
(when load-file-name
  (defvar shrink-path-test/test-path
    (directory-file-name (file-name-directory load-file-name))
    "Path to tests directory.")

  (defvar shrink-path-test/root-path
    (directory-file-name (file-name-directory shrink-path-test/test-path))
    "Path to root directory.")

  (defvar shrink-path-test/playground-path
    (expand-file-name "playground" shrink-path-test/test-path)
    "Path to playground directory")

  (defvar shrink-path-el (expand-file-name "shrink-path.el" shrink-path-test/root-path))

  (load shrink-path-el 'noerror 'nomessage))

(defmacro with-home (home &rest body)
  "Within HOME environment evaluate BODY."
  (declare (indent 1))
  `(let ((abbreviated-home-dir nil) ; needed for interactive emacs
         (before (getenv "HOME")))
     (unwind-protect
         (progn
           (setenv "HOME" ,home)
           ,@body)
       (setenv "HOME" before))))

(defmacro with-playground (&rest body)
  "Sets up empty playground directory and yields BODY in this environment.
PLAYGROUND-PATH is available in BODY."
  (declare (indent 0))
  `(unwind-protect
       (progn
         (let ((playground-path shrink-path-test/playground-path))
           (make-directory shrink-path-test/playground-path)
           (with-home shrink-path-test/playground-path
             ,@body)))
     (delete-directory shrink-path-test/playground-path 'recursive)))
