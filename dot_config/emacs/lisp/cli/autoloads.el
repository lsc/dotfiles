;;; lisp/cli/autoloads.el -*- lexical-binding: t; -*-
;;; Commentary:
;;
;; DEPRECATED: Old autoload processing library, replaced by cli/loaddefs.el.
;; Will be removed in v3.
;;
;;; Code:

(defvar doom-autoloads-excluded-files ()
  "List of regexps whose matching files won't be indexed for autoloads.")
(make-obsolete-variable 'doom-autoloads-excluded-files
                        "Filter files before passing them to `doom-autoloads--scan'"
                        "2.3.0")

(define-obsolete-variable-alias 'doom-autoloads-cached-vars 'doom-loaddefs-excluded-vars "2.3.0")


;;
;;; * Library

(doom-require 'doom-cli 'loaddefs)

;; DEPRECATED: Remove in v3
(define-obsolete-function-alias 'doom-autoloads--cleanup-form #'doom-loaddefs--clean "2.3.0")

;; DEPRECATED: Remove in v3
(define-obsolete-function-alias 'doom-autoloads--scan-autodefs #'doom-loaddefs--scan-autodefs "2.3.0")

;; DEPRECATED: Remove in v3
(define-obsolete-function-alias 'doom-autoloads--scan-file #'doom-loaddefs--scan-file "2.3.0")

;; DEPRECATED: Remove in v3 (replaced by lib/loaddefs.el)
(defun doom-autoloads--scan (files &optional exclude literal)
  "Scan and return all autoloaded forms in FILES.

Autoloads will be generated from autoload cookies in FILES (except those that
match one of the regexps in EXCLUDE -- a list of strings). If LITERAL is
non-nil, treat FILES as pre-generated autoload files instead."
  (quiet! ; silence deprecation notices in 30+
    (require 'autoload))
  (let (seen autoloads)
    (dolist (file files `((let ((load-in-progress t))
                            ,@(nreverse (delq nil autoloads)))))
      (setq file (file-truename file))
      (when (and (not (seq-find (doom-rpartial #'string-match-p file) exclude))
                 (not (member file seen))
                 (file-readable-p file))
        (doom-log "loaddefs:scan: %s" file)
        (push file seen)
        (with-temp-buffer
          (let (subautoloads)
            (if literal
                (insert-file-contents file)
              (doom-autoloads--scan-file file))
            (save-excursion
              ;; Fixup the special #$ reader form and throw away comments.
              (while (re-search-forward "#\\$\\|^;\\(.*\n\\)" nil 'move)
                (unless (ppss-string-terminator (save-match-data (syntax-ppss)))
                  (replace-match (if (match-end 1) "" file) t t))))
            (let ((load-file-name file)
                  (load-true-file-name load-file-name)
                  (load-path
                   (append (list doom-user-dir)
                           doom-module-load-path
                           load-path)))
              (condition-case _
                  (while t
                    (push (doom-loaddefs--clean load-file-name
                                                (read (current-buffer))
                                                (not literal))
                          subautoloads))
                (end-of-file)))
            (when (delq nil subautoloads)
              (push `(let* ((load-file-name ,file)
                            (load-true-file-name load-file-name))
                       ,@(nreverse subautoloads))
                    autoloads))))))))

(provide 'doom-cli '(autoloads))
;;; autoloads.el end here
