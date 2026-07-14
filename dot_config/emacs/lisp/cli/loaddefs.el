;;; lisp/cli/loaddefs.el -*- lexical-binding: t; -*-
;;; Commentary:
;;
;; Doom's spin on loaddefs.el, which isn't extensible enough for us to build on
;; top of. This library, on top of regular ;;;###autoload cookies, adds support
;; for:
;;
;;   - Autoloading `defcli!'s (converting them in to `defcli-autoload!' calls)
;;   - Reading ;;;###autodef cookies (autoloaded functions/macros that are
;;     always defined, even if their containing module is disabled — they're
;;     replaced with a no-op).
;;   - Cleaning up extra, unneeded work done in autoloads files.
;;   - Expanding paths in package autoloads to reduce load-path lookups.
;;
;;; Code:

(defvar doom-loaddefs-excluded-vars
  '(load-path
    auto-mode-alist
    interpreter-mode-alist
    magic-mode-alist
    magic-fallback-mode-alist)
  "A list of variables to remove `add-to-list' calls for in autoloads.

These are removed because Doom's profiles batch these calls in their init
file.")

(defvar doom-loaddefs--path-cache nil)


;;
;;; * Helpers

(defun doom-loaddefs--locate-file (path)
  (or (cdr (assoc path doom-loaddefs--path-cache))
      (when-let* ((libpath (locate-library path))
                  (libpath (file-name-sans-extension libpath))
                  (libpath (abbreviate-file-name libpath)))
        (push (cons path libpath) doom-loaddefs--path-cache)
        libpath)
      (and (stringp path) (abbreviate-file-name path))
      path))

(defun doom-loaddefs--clean (file form &optional expand-autoloads?)
  (let ((f (car-safe form)))
    (cond ((memq f '(provide custom-autoload register-definition-prefixes))
           nil)

          ((and (eq f 'add-to-list)
                (memq (doom-unquote (cadr form))
                      doom-loaddefs-excluded-vars))
           nil)

          ((eq f 'defcli!)
           (setcar form 'defcli-autoload!)
           (setcdr form (list (cadr form) (doom-loaddefs--locate-file file)))
           form)

          ((and (eq f 'autoload)
                expand-autoloads?
                (not (file-name-absolute-p (nth 2 form))))
           (setf (nth 2 form) (doom-loaddefs--locate-file (nth 2 form)))
           form)

          (form))))

(defun doom-loaddefs--scan-autodefs (file buffer module &optional module-enabled-p)
  (with-temp-buffer
    (insert-file-contents file)
    (while (re-search-forward "^;;;###autodef *\\([^\n]+\\)?\n" nil t)
      (let* ((standard-output buffer)
             (form    (read (current-buffer)))
             (altform (match-string 1))
             (definer (car-safe form))
             (symbol  (doom-unquote (cadr form))))
        (cond ((and (not module-enabled-p) altform)
               (print (read altform)))
              ((memq definer '(defun defmacro cl-defun cl-defmacro))
               (print
                (if module-enabled-p
                    (make-autoload form (abbreviate-file-name file))
                  (seq-let (_ _ arglist &rest body) form
                    (if altform
                        (read altform)
                      (append
                       (list (pcase definer
                               (`defun 'defmacro)
                               (`cl-defun `cl-defmacro)
                               (_ definer))
                             symbol arglist
                             (format "THIS FUNCTION DOES NOTHING BECAUSE %s IS DISABLED\n\n%s"
                                     module (if (stringp (car body))
                                                (pop body)
                                              "No documentation.")))
                       (cl-loop for arg in arglist
                                if (symbolp arg)
                                if (not (keywordp arg))
                                if (not (memq arg cl--lambda-list-keywords))
                                collect arg into syms
                                else if (listp arg)
                                collect (car arg) into syms
                                finally return (if syms `((ignore ,@syms)))))))))
               (print `(put ',symbol 'doom-module ',module)))
              ((eq definer 'defalias)
               (seq-let (_ _ target docstring) form
                 (unless module-enabled-p
                   (setq target #'ignore
                         docstring
                         (format "THIS FUNCTION DOES NOTHING BECAUSE %s IS DISABLED\n\n%s"
                                 module docstring)))
                 (print `(put ',symbol 'doom-module ',module))
                 (print `(defalias ',symbol #',(doom-unquote target) ,docstring))))
              (module-enabled-p (print form)))))))

(defun doom-loaddefs--scan-file (file)
  ;; FIXME: Conditionally use `loaddefs' in Emacs 30+
  (quiet! (require 'autoload))  ; silence deprecation notice
  (dlet (;; Prevent `autoload-find-file' from firing file hooks, e.g. adding
         ;; to recentf.
         find-file-hook
         write-file-functions
         ;; Prevent a possible source of crashes when there's a syntax error in
         ;; the autoloads file.
         debug-on-error
         ;; Non-nil interferes with autoload generation in Emacs < 29. See
         ;; radian-software/straight.el#904.
         (left-margin 0)
         ;; The following bindings are in `package-generate-autoloads'.
         ;; Presumably for a good reason, so I just copied them.
         (backup-inhibited t)
         (version-control 'never)
         case-fold-search    ; reduce magic
         autoload-timestamps ; reduce noise in generated files
         autoload-compute-prefixes
         (generated-autoload-load-name
          (abbreviate-file-name (file-name-sans-extension file))))
    (let* ((module (doom-module-from-path file))
           (module-enabled-p
            (and (doom-module-active-p (car module) (cdr module))
                 (doom-file-cookie-p file "if" t)))
           ;; So `autoload-generate-file-autoloads' knows where to write it
           (target-buffer (current-buffer)))
      (save-excursion
        (when module-enabled-p
          (quiet! (autoload-generate-file-autoloads file target-buffer)))
        (doom-loaddefs--scan-autodefs
         file target-buffer module module-enabled-p)))))

(defun doom-loaddefs--read (files thunk &optional literal?)
  (let (seen forms)
    (dolist (file (thread-last files
                               (flatten-list)
                               (remq nil)
                               (mapcar #'file-truename)
                               (delete-dups)))
      (when (and (not (member file seen))
                 (file-readable-p file))
        (push file seen)
        (doom-log "loaddefs:read: %s (%s)"
                  (abbreviate-file-name file)
                  (if (symbolp thunk) thunk "<lambda>"))
        (with-temp-buffer
          (let (subautoloads)
            (funcall thunk file)
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
                    (push (doom-loaddefs--clean
                           file (read (current-buffer)) (not literal?))
                          subautoloads))
                (end-of-file)))
            (when (delq nil subautoloads)
              (push `(let* ((load-file-name ,(abbreviate-file-name file))
                            (load-true-file-name load-file-name))
                       ,@(nreverse subautoloads))
                    forms))))))
    `((let ((load-in-progress t)) ,@(nreverse (delq nil forms))))))


;;
;;; * Public functions

(defun doom-loaddefs-scan (&rest files)
  (doom-loaddefs--read
   files #'doom-loaddefs--scan-file))

(defun doom-loaddefs-scan-literal (&rest files)
  (doom-loaddefs--read
   files #'insert-file-contents t))

(provide 'doom-cli '(loaddefs))
;;; loaddefs.el end here
