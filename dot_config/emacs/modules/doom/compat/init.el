;;; modules/doom/compat/init.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;;
;;; * Deprecated variables/constants/features

(with-no-warnings
  (defconst EMACS28+    (> emacs-major-version 27))
  (defconst EMACS29+    (> emacs-major-version 28))
  (defconst MODULES     (bound-and-true-p module-file-suffix))
  (defconst NATIVECOMP  (featurep 'native-compile))

  (make-obsolete-variable 'EMACS28+   "Use (>= emacs-major-version 28) instead" "2.1.0")
  (make-obsolete-variable 'EMACS29+   "Use (>= emacs-major-version 29) instead" "2.1.0")
  (make-obsolete-variable 'MODULES    "Use (bound-and-true-p module-file-suffix) instead" "2.1.0")
  (make-obsolete-variable 'NATIVECOMP "Use (featurep 'native-compile) instead" "2.1.0"))

(define-obsolete-variable-alias 'doom-private-dir 'doom-user-dir "2.1.0")
(define-obsolete-variable-alias 'doom-etc-dir 'doom-data-dir "2.1.0")

;; Emacs needed a more consistent way to detect build features, and the docs
;; claim `system-configuration-features' is not da way. Some features (that
;; don't represent packages) can be found in `features' (which `featurep'
;; consults), but aren't consistent, so I thoguht i'd impose some consistency,
;; but I ended up not using these often enough to justify them (and they'd just
;; confuse folks into believing Emacs is supplying these).
(if (bound-and-true-p module-file-suffix)
    (push 'dynamic-modules features))
(if (fboundp #'json-parse-string)
    (push 'jansson features))
(if (string-match-p "HARFBUZZ" system-configuration-features) ; no alternative
    (push 'harfbuzz features))



;;
;;; * Deprecated functions/macros

;; lisp/lib/files.el
(define-obsolete-function-alias 'doom-dir 'doom-path "2.1.0")

;; lisp/lib/plist.el
(define-obsolete-function-alias 'doom-plist-get #'cl-getf "2.1.0")

;; lisp/doom-*.el
(define-obsolete-variable-alias 'doom-unicode-font 'doom-symbol-font "2.1.0")
(define-obsolete-variable-alias 'doom-projectile-fd-binary 'doom-fd-executable "2.1.0")

;; lisp/doom-lib.el
(define-obsolete-function-alias 'featurep! 'modulep! "2.1.0")
(define-obsolete-function-alias 'doom-enlist 'ensure-list "2.1.0")
(define-obsolete-function-alias 'letenv! 'with-environment-variables "2.1.0")
(define-obsolete-function-alias 'eval-if! 'static-if "2.1.0")
(define-obsolete-function-alias 'eval-when! 'static-when "2.1.0")
(define-obsolete-function-alias 'setq! 'setopt "2.1.0")

(defun doom-load-envvars-file (file &optional noerror)
  "Read and set envvars from FILE.
If NOERROR is non-nil, don't throw an error if the file doesn't exist or is
unreadable. Returns the names of envvars that were changed."
  (if (null (file-exists-p file))
      (unless noerror
        (signal 'file-error (list "No envvar file exists" file)))
    (with-temp-buffer
      (insert-file-contents file)
      (when-let* ((env (read (current-buffer))))
        (let ((tz (getenv-internal "TZ")))
          (setq-default
           process-environment
           (append env (default-value 'process-environment))
           exec-path
           (append (split-string (getenv "PATH") path-separator t)
                   (list exec-directory))
           shell-file-name
           (or (getenv "SHELL")
               (default-value 'shell-file-name)))
          (when-let* ((newtz (getenv-internal "TZ")))
            (unless (equal tz newtz)
              (set-time-zone-rule newtz))))
        env))))

(defun doom-compile-functions (&rest fns)
  "Queue FNS to be byte/natively-compiled after a brief delay."
  (with-memoization (get 'doom-compile-function 'timer)
    (run-with-idle-timer
     1.5 t (fn! (when-let* ((fn (pop fns)))
                  (doom-log 3 "compile-functions: %s" fn)
                  (or (if (featurep 'native-compile)
                          (or (subr-native-elisp-p (indirect-function fn))
                              (ignore-errors (native-compile fn))))
                      (byte-code-function-p fn)
                      (let (byte-compile-warnings)
                        (byte-compile fn))))
                (unless fns
                  (cancel-timer (get 'doom-compile-function 'timer))
                  (put 'doom-compile-function 'timer nil))))))

(defmacro appendq! (sym &rest lists)
  "Append LISTS to SYM in place."
  (declare (obsolete "Use `cl-callf' instead" "2.1.0"))
  `(setq ,sym (append ,sym ,@lists)))

(defmacro delq! (elt list &optional fetcher)
  "`delq' ELT from LIST in-place.

If FETCHER is a function, ELT is used as the key in LIST (an alist)."
  (declare (obsolete "Use `cl-callf2' or `alist-get' instead" "2.1.0"))
  `(setq ,list (delq ,(if fetcher
                          `(funcall ,fetcher ,elt ,list)
                        elt)
                     ,list)))

(defmacro pushnew! (place &rest values)
  "Push VALUES sequentially into PLACE, if they aren't already present.
This is a variadic `cl-pushnew'."
  (declare (obsolete "Use a loop with `add-to-list' or `cl-pushnew' instead" "2.1.0"))
  (let ((var (make-symbol "result")))
    `(dolist (,var (list ,@values) (with-no-warnings ,place))
       (cl-pushnew ,var ,place :test #'equal))))

(defmacro prependq! (sym &rest lists)
  "Prepend LISTS to SYM in place."
  (declare (obsolete "Use `cl-callf2' instead" "2.1.0"))
  `(setq ,sym (append ,@lists ,sym)))


;;
;;; * Deprecated sub-modules

(load! "+use-package")
(if (modulep! +keybinds)    (load! "+keybinds"))  ; `general' & `map!'
(if (modulep! +projectile)  (load! "+projectile"))
(if (modulep! +smartparens) (load! "+smartparens"))
(if (modulep! +better-jumper) (load! "+better-jumper"))

;;; init.el ends here
