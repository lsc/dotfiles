;;; lisp/doom-profiles.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;;
;;; * Variables

(defvar doom-profiles-generated-dir doom-data-dir
  "Where generated profiles are kept.

Profile directories are in the format {data-profiles-dir}/$NAME/@/$VERSION, for
example: '~/.local/share/doom/_/@/0/'")

(defvar doom-profile-load-path
  (append
   (when-let* ((path (getenv-internal "DOOMPROFILELOADPATH")))
     (mapcar #'doom-path (split-string-and-unquote path path-separator)))
   (list (doom-user-dir "profiles.el")
         (expand-file-name
          "doom-profiles.el" (or (getenv "XDG_CONFIG_HOME") "~/.config"))
         (expand-file-name "~/.doom-profiles.el")
         (doom-emacs-dir "profiles.el")
         (doom-user-dir "profiles")
         (doom-emacs-dir "profiles")))
  "A list of profile config files or directories that house implicit profiles.

`doom-profiles-initialize' loads and merges all profiles defined in the above
files/directories, then writes a profile load script to
`doom-profile-load-file'.

Can be changed externally by setting $DOOMPROFILELOADPATH to a colon-delimited
list of paths or profile config files (semi-colon delimited on Windows).")

(defvar doom-profile-load-file
  ;; REVIEW: Derive from `doom-data-dir' in v3
  (expand-file-name
   (or (getenv-internal "DOOMPROFILELOADFILE")
       (file-name-concat (if doom--system-windows-p "doomemacs/data" "doom")
                         "profiles.el"))
   (or (if doom--system-windows-p
           (getenv-internal "LOCALAPPDATA"))
       (getenv-internal "XDG_DATA_HOME")
       "~/.local/share"))
  "Where Doom writes its interactive profile loader script.

Can be changed externally by setting $DOOMPROFILELOADFILE.")

(defvar doom-profile-cache-file (doom-cache-dir "profiles.%s.el")
  "Where Doom writes its interactive profile loader script.

Can be changed externally by setting $DOOMPROFILELOADFILE.")

(defvar doom-profile-init-dir-name "init.d"
  "The subdirectory of `doom-profile-dir'")

(defvar doom-profile-rcfile ".doomprofile"
  "The filename for local user configuration of a Doom profile.")

;;; Profile storage variables
(define-obsolete-variable-alias 'doom-profile-generators 'doom-profile-generate-functions "2.3.0")
(defvar doom-profile-generate-functions
  '(doom-profile--generate-init
    doom-profile--generate-loaddefs-doom
    doom-profile--generate-user-init-loader
    doom-profile--generate-package-envs
    doom-profile--generate-loaddefs-packages
    doom-profile--generate-loaddefs-modules
    doom-profile--generate-module-loader)
  "An alist mapping file names to generator functions.

Functions are responsible for generating the profile init files that will be
concatenated into a single, monolithic one. Init files should be prefixed with a
two digit number so they execute in the desired order. Init files with the
following suffixes have special behaviors:

  *.init.el -- will be concatenated verbatim into the profile init file.
  *.load.el -- will be `doom-load'ed by the profile init file.

These functions are executed in the context of the
`doom-profile-dir'/`doom-profile-init-dir-name' directory.")

(defvar doom--profiles ())


;;
;;; * Bootstrappers

;; (defun doom-profile-initialize (profile &optional project-dir nocache?))


;;
;;; * Library

;;;###autoload
(eval-and-compile
  (cl-defstruct (doom-profile (:copier nil))
    "TODO"
    name
    ref
    root
    ;; hash       ; profile is initialized & synced
    active-p
    ;; recipe-overrides
    ;; source-overrides
    ;; module-overrides
    ;; package-overrides
    ;; (sources (make-hash-table :test 'eq) :read-only t)
    ;; (modules (make-hash-table :test 'equal) :read-only t)
    ;; (packages (make-hash-table :test 'eq) :read-only t)
    ;; (-module-paths (make-hash-table :test 'equal) :read-only t)
    ;; (-source-paths (make-hash-table :test 'equal) :read-only t)
    ;; (metadata '((t)))
    ;; bindings
    ;; (build-system system-configuration)
    ;; (build-version emacs-version)
    ;; build-time
    )

  (pcase-defmacro doom-profile (&rest fields)
    `(doom-struct doom-profile ,@fields))

  (defun doom-profile-key (profile &optional default?)
    "Normalize PROFILE into a (NAME . REF) doom-profile key.

PROFILE can be a `doom-profile' struct, a profile id string (in the NAME@REF
format), a (NAME . REF) cons cell, or `t' to return the fallback key:
(\"_default\" .  0).

NAME is the string name of the profile and REF can either be a string (arbitrary
label) or an integer (generation number).

Throws `wrong-type-argument' if PROFILE is nil and DEFAULT? is omitted.

If DEFAULT? is non-nil, an unspecified NAME and/or REF field will be filled in
with the corresponding one from the fallback key."
    (declare (pure t) (side-effect-free t))
    (let ((default-name (if default? (car doom--profile-default)))
          (default-ref  (if default? (cdr doom--profile-default))))
      (cond ((or (eq profile t)
                 (and (null profile) default?))
             (cons default-name default-ref))
            ((stringp profile)
             (save-match-data
               (let (case-fold-search)
                 (if (string-match "^\\([^@]+\\)?\\(?:@\\(.+\\)\\)?$" profile)
                     (cons (match-string 1 profile)
                           (or (match-string 2 profile) default-ref))
                   (cons profile default-name)))))
            ((doom-profile-p profile)
             (cons (or (doom-profile-name profile) default-name)
                   (or (doom-profile-ref profile)  default-ref)))
            ((and (consp profile) (nlistp (cdr profile)))
             (cons (or (car profile) default-name)
                   (or (cdr profile) default-ref)))
            ((signal 'wrong-type-argument
                     (list "Expected PROFILE to be a string, cons cell, or `doom-profile'"
                           (type-of profile) profile)))))))

;;;###autoload
(defun copy-doom-profile (profile &optional ref deep?)
  "Return a copy of PROFILE at REF.

If REF is t, use the next available REF for PROFILE.
If REF is :last, use the last known, built ref of PROFILE.
If REF is any other string, set PROFILE's REF to it.

If DEEP is non-nil, produce a deep copy of PROFILE. Otherwise, a barebones,
uninitialized copy of PROFILE is returned."
  (let ((p (doom-copy profile deep?)))
    (when ref
      (setf (doom-profile-ref p)
            (if (memq ref '(t :last))
                (cdr (doom-profile-key nil t))  ; refs are ornamental until v3
              ref)))
    p))

;; (defun doom-profile-get (profile-name &optional property null-value)
;;   "Return PROFILE-NAME's PROFILE, otherwise its PROPERTY, otherwise NULL-VALUE."
;;   (when (stringp profile-name)
;;     (setq profile-name (intern profile-name)))
;;   (if-let* ((profile (assq profile-name (doom-profiles))))
;;       (if property
;;           (if-let* ((propval (assq property (cdr profile))))
;;               (cdr propval)
;;             null-value)
;;         profile)
;;     null-value))

;;;###autoload
(defun doom-profile->id (profile)
  "Return a NAME@VERSION id string from PROFILE.

See `doom-profile-key' for possible values of PROFILE."
  (cl-destructuring-bind (name . ref) (doom-profile-key profile)
    (format "%s@%s" name ref)))


;;; ** Profile load file

(defun doom-profiles-bootloadable-p ()
  "Return non-nil if `doom-emacs-dir' can be a bootloader.

This means it must be deployed to $XDG_CONFIG_HOME/emacs or $HOME/.emacs.d. Doom
cannot bootload from an arbitrary location."
  (with-memoization (get 'doom 'bootloader)
    (or (file-equal-p doom-emacs-dir "~/.emacs.d")
        (file-equal-p
         doom-emacs-dir (expand-file-name
                         "emacs/" (or (getenv "XDG_CONFIG_HOME")
                                      "~/.config"))))))

(defun doom-profiles-read (&rest paths)
  "TODO"
  (let ((key (doom-profile-key t))
        profiles)
    (dolist (path (delq nil (flatten-list paths)))
      (cond
       ((file-directory-p path)
        (setq path (file-truename path))
        (dolist (subdir (doom-files-in path :depth 0 :match "/[^.][^/]+$" :type 'dirs :map #'file-name-base))
          (if (equal subdir (car key))
              (signal 'doom-profile-error (list (file-name-concat path subdir) "Implicit profile has invalid name"))
            (unless (string-prefix-p "_" subdir)
              (cl-pushnew
               (cons (intern subdir)
                     (let* ((val (abbreviate-file-name (file-name-as-directory subdir)))
                            (val (if (file-name-absolute-p val)
                                     `(,val)
                                   `(,(abbreviate-file-name path) ,val))))
                       (cons `(user-emacs-directory :path ,@val)
                             (doom-config `(,(doom-path path subdir) profile)))))
               profiles
               :test #'eq
               :key #'car)))))
       ((file-exists-p path)
        (dolist (profile (car (doom-file-read path :by 'read*)))
          (if (eq (symbol-name (car profile)) (car key))
              (signal 'doom-profile-error (list path "Profile has invalid name: _"))
            (unless (string-prefix-p "_" (symbol-name (car profile)))
              (cl-pushnew profile profiles
                          :test #'eq
                          :key #'car)))))))
    (nreverse profiles)))

(defun doom-profiles-write-load-file (profiles &optional file)
  "Generate a profile bootstrapper for Doom to load at startup."
  (unless file
    (setq file doom-profile-load-file))
  (doom-file-write
   file `(";; -*- lexical-binding: t; tab-width: 8; -*-\n"
          ";; Updated: " ,(format-time-string "%Y-%m-%d %H:%M:%S") "\n"
          ";; Generated by 'doom profile sync' or 'doom sync'.\n"
          ";; DO NOT EDIT THIS BY HAND!\n"
          ,(format "%S" doom-version)
          (pcase (intern (getenv-internal "DOOMPROFILE"))
            ,@(cl-loop
               for (profile-name . bindings) in profiles
               for deferred?
               = (seq-find (fn! (and (memq (car-safe (cdr %)) '(:prepend :prepend? :append :append?))
                                     (not (stringp (car-safe %)))))
                           bindings)
               collect
               `(',profile-name
                 (let ,(if deferred? '(--deferred-vars--))
                   ,@(cl-loop
                      for (var . val) in bindings
                      collect
                      (pcase (car-safe val)
                        (:path
                         `(,(if (stringp var) 'setenv 'setq)
                           ,var ,(cl-loop with form = `(expand-file-name ,(cadr val) user-emacs-directory)
                                          for dir in (cddr val)
                                          do (setq form `(expand-file-name ,dir ,form))
                                          finally return form)))
                        (:eval
                         (if (eq var '_)
                             (macroexp-progn (cdr val))
                           `(,(if (stringp var) 'setenv 'setq)
                             ,var ,(macroexp-progn (cdr val)))))
                        (:plist
                         `(,(if (stringp var) 'setenv 'setq)
                           ,var ',(if (stringp var)
                                      (prin1-to-string (cadr val))
                                    (cadr val))))
                        ((or :prepend :prepend?)
                         (if (stringp var)
                             `(setenv ,var (concat ,val (getenv ,var)))
                           (setq deferred? t)
                           `(push (cons ',var
                                        (lambda ()
                                          (dolist (item (list ,@(cdr val)))
                                            ,(if (eq (car val) :append?)
                                                 `(add-to-list ',var item)
                                               `(push item ,var)))))
                                  --deferred-vars--)))
                        ((or :append :append?)
                         (if (stringp var)
                             `(setenv ,var (concat (getenv ,var) ,val))
                           (setq deferred? t)
                           `(push (cons ',var
                                        (lambda ()
                                          (dolist (item (list ,@(cdr val)))
                                            ,(if (eq (car val) :append?)
                                                 `(add-to-list ',var item 'append)
                                               `(set ',var (append ,var (list item)))))))
                                  --deferred-vars--)))
                        (_ `(,(if (stringp var) 'setenv 'setq) ,var ',val))))
                   ,@(when deferred?
                       `((defun --doom-profile-set-deferred-vars-- (_)
                           (dolist (var --deferred-vars--)
                             (when (boundp (car var))
                               (funcall (cdr var))
                               (setq --deferred-vars-- (delete var --deferred-vars--))))
                           (unless --deferred-vars--
                             (remove-hook 'after-load-functions #'--doom-profile-set-deferred-vars--)
                             (unintern '--doom-profile-set-deferred-vars-- obarray)))
                         (add-hook 'after-load-functions #'--doom-profile-set-deferred-vars--)
                         (--doom-profile-set-deferred-vars-- nil)))))))
          ;; `user-emacs-directory' requires that it end in a directory
          ;; separator, but users may forget this in their profile configs.
          (setq user-emacs-directory (file-name-as-directory user-emacs-directory)))
   :mode (cons #o600 #o700)
   :printfn #'prin1)
  (print-group!
    (or (let ((byte-compile-debug t)
              (byte-compile-warnings (if init-file-debug byte-compile-warnings))
              (byte-compile-dest-file-function
               (lambda (_) (format "%s.elc" (file-name-sans-extension file)))))
          (byte-compile-file file))
        ;; Do it again? So the errors/warnings are visible?
        ;; (let ((byte-compile-warnings t))
        ;;   (byte-compile-file file))
        (signal 'doom-profile-error (list file "Failed to byte-compile bootstrap file")))))

(defun doom-profiles-autodetect (&optional _internal?)
  "Return all known profiles as a nested alist.

This reads all profile configs and directories in `doom-profile-load-path', then
caches them in `doom--profiles'. If RELOAD? is non-nil, refresh the cache."
  (doom-profiles-read doom-profile-load-path
                      ;; TODO: Add in v3
                      ;; (if internal? doom-profiles-generated-dir)
                      ))

(defun doom-profiles-outdated-p ()
  "Return non-nil if files in `doom-profile-load-file' are outdated."
  (cl-loop for path in doom-profile-load-path
           when (string-suffix-p path ".el")
           if (or (not (file-exists-p doom-profile-load-file))
                  (file-newer-than-file-p path doom-profile-load-file)
                  (not (equal (doom-file-read doom-profile-load-file :by 'read)
                              doom-version)))
           return t))


;;; ** Profile Generators

(defun doom-profile-generate (&optional profile reload?)
  "Generate profile init files."
  (doom-initialize-packages)
  (let* ((p (or profile doom-profile))
         (default-directory (doom-profile-init-dir p))
         (init-dir  (doom-profile-init-dir p doom-profile-init-dir-name))
         (init-dir* (doom-profile-dir p doom-profile-init-dir-name))
         (init-file (doom-profile-init-file p)))
    (print! (start "Generating profile init file"))
    (condition-case-unless-debug e
        (with-file-modes #o750
          (print-group!
            (if reload?
                (if (not (file-directory-p init-dir))
                    (user-error "No pre-existing profile to reload")
                  (cl-loop for file in (doom-glob init-dir* "*.el")
                           do (copy-file file (file-name-as-directory init-dir) t)))
              (delete-directory init-dir t)
              (make-directory init-dir t)
              ;; Where persisted profile files are preserved.
              (when (file-directory-p init-dir*)
                (copy-directory init-dir* init-dir nil t t))
              (let ((default-directory (doom-path init-dir)))
                ;; TODO: (run-hook-with-args 'doom-profile-generate-functions p)
                (dolist (fn doom-profile-generate-functions)
                  (if (symbolp fn)
                      (funcall fn p)
                    ;; DEPRECATED: Backwards compatibility. Remove in v3.
                    (pcase-let* ((`(,file ,fn _) fn)
                                 (file (doom-path init-dir file)))
                      (doom-log "Building %s..." file)
                      (doom-file-write file (funcall fn) :printfn #'prin1))))))
            (doom-file-write
             init-file
             `(";; -*- coding: utf-8; lexical-binding: t; no-byte-compile: t -*-"
               ";; This file was autogenerated; do not edit it by hand!"
               ,@(cl-loop for file in (doom-glob init-dir "*.el")
                          do (print! (item "Reading %s...") (filename file))
                          if (and (or (string-suffix-p ".init.el" file)
                                      ;; DEPRECATED: Backwards compatibility.
                                      ;;   Remove in v3.
                                      (string-suffix-p ".auto.el" file))
                                  (doom-file-cookie-p file "if" t))
                          append (doom-file-read file :by 'read*)
                          else if (string-suffix-p ".load.el" file)
                          collect `(if ,(doom-file-cookie file "if" t)
                                       (doom-load ,(abbreviate-file-name file)
                                                  t)))
               ;; DEPRECATED: Backwards compatibility. Remove in v3.
               ,@(cl-loop for fn in doom-profile-generate-functions
                          if (not (functionp fn))
                          if (functionp (nth 2 fn))
                          collect `(add-hook 'doom-startup-functions ',(nth 2 fn) 'append))))
            (print! (success "Built %s") (filename init-file))))
      (error (ignore-errors (delete-file init-file))
             (signal 'doom-autoload-error (list init-file e))))))

(defun doom-profile--generate-init (profile)
  (doom-file-write
   "05-doom.init.el"
   `((setq doom-profile ,profile)
     (defun doom--startup-vars (_profile)
       (when (doom-context-p 'reload)
         (set-default-toplevel-value 'load-path (get 'load-path 'initial-value)))
       ,@(cl-loop for var in '(auto-mode-alist
                               interpreter-mode-alist
                               magic-mode-alist
                               magic-fallback-mode-alist)
                  collect `(set-default-toplevel-value ',var ',(symbol-value var)))
       ;; Ensure site lisp entries are placed at the end of `load-path' in
       ;; interactive sessions, or malformed/strange EMACSLOADPATH values could
       ;; mess with load order expectations.
       ,@(cl-loop for path in (reverse (get 'load-path 'initial-value))
                  collect `(add-to-list 'load-path ,path))
       ,@(cl-loop with init-load-path = (get 'load-path 'initial-value)
                  with site-run-dir =
                  (ignore-errors
                    (directory-file-name (file-name-directory
                                          (locate-library site-run-file))))
                  for path in load-path
                  unless (member path init-load-path)
                  unless (file-equal-p path doom-core-dir)
                  unless (file-in-directory-p path data-directory)
                  unless (and site-run-dir (file-in-directory-p path site-run-dir))
                  collect `(add-to-list 'load-path ,path))
       ,@(cl-loop with v = (version-to-list doom-version)
                  with emacs-dir = (doom-emacs-dir)
                  with ref = (doom-call-process "git" "-C" emacs-dir "rev-parse" "HEAD")
                  with branch = (doom-call-process "git" "-C" emacs-dir "branch" "--show-current")
                  for (var . val)
                  in `((major  . ,(nth 0 v))
                       (minor  . ,(nth 1 v))
                       (build  . ,(nth 2 v))
                       (tag    . ,(ignore-errors (cadr (split-string doom-version "-" t))))
                       (ref    . ,(if (zerop (car ref)) (cdr ref)))
                       (branch . ,(if (zerop (car branch)) (cdr branch))))
                  collect `(put 'doom-version ',var ',val)))
     (add-hook 'doom-startup-functions #'doom--startup-vars 5))))

(defun doom-profile--generate-loaddefs-doom (_profile)
  (doom-file-write
   "10-doom-loaddefs.init.el"
   `((static-unless noninteractive
       ,@(doom-loaddefs-scan (doom-glob doom-core-dir "doom-*.el")))))
  (doom-file-write
   "10-doom-cli-loaddefs.load.el"
   `(";; -*- lexical-binding: t; no-byte-compile t; -*-"
     ";;;###if noninteractive"
     ,@(doom-loaddefs-scan
        (cl-loop for dir in (doom-module-load-path nil t)
                 append (doom-glob dir doom-module-cli-file))
        (doom-glob doom-core-dir "cli/*.el")
        (seq-filter
         #'doom-cli-executable-p
         (cl-loop for dir in doom-cli-load-path
                  append (doom-glob dir "doom-*")
                  append (doom-glob dir "doom-*.el")))))))

(defun doom-profile--generate-user-init-loader (_profile)
  (doom-file-write
   "20-user.init.el"
   `((static-unless noninteractive
       (with-doom-context '(module init)
         (doom-load ,(doom-user-dir doom-module-init-file) t))))))

(defun doom-profile--generate-package-envs (_profile)
  (doom-file-write
   "30-doom-package-envs.init.el"
   `((static-unless noninteractive
       ,@(cl-loop for (_ . plist) in doom-packages
                  if (plist-get plist :env)
                  append (cl-loop for (var . val) in it
                                  if (and (stringp var) val)
                                  collect `(setenv ,var ,val)
                                  else if (and (symbolp var)
                                               (string-prefix-p "_" (symbol-name var)))
                                  collect `(setq-default ,var ,val)))))))

(defun doom-profile--generate-loaddefs-modules (_profile)
  (doom-file-write
   "60-doom-module-loaddefs.init.el"
   `((defun doom--startup-loaddefs-modules (_profile)
       ,@(doom-loaddefs-scan
          (doom-glob doom-core-dir "lib/*.el")
          (cl-loop for dir
                   in (append (doom-module-load-path :all t)
                              (list doom-user-dir))
                   if (doom-glob dir "autoload.el") collect (car it)
                   if (doom-glob dir "autoload/*.el") append it)))
     (add-hook 'doom-startup-functions #'doom--startup-loaddefs-modules 60))))

(defun doom-profile--generate-loaddefs-packages (_profile)
  (doom-file-write
   "70-doom-package-loaddefs.init.el"
   `((defun doom--startup-loaddefs-packages (_profile)
       ,@(doom-loaddefs-scan-literal
          ;; Create a list of packages starting with the Nth-most dependencies
          ;; by walking the package dependency tree depth-first. This ensures
          ;; any load-order constraints in package autoloads are always met.
          (let (packages)
            (letf! (defun* walk-packages (pkglist)
                     (cond ((null pkglist) nil)
                           ((stringp pkglist)
                            (walk-packages (nth 1 (gethash pkglist straight--build-cache)))
                            (cl-pushnew pkglist packages :test #'equal))
                           ((listp pkglist)
                            (mapc #'walk-packages (reverse pkglist)))))
              (walk-packages (mapcar #'symbol-name (mapcar #'car doom-packages))))
            (mapcar #'straight--autoloads-file (nreverse packages))))
       ,@(when-let* ((info-dirs
                      (cl-loop for dir in load-path
                               if (file-exists-p (doom-path dir "dir"))
                               collect dir)))
           `((with-eval-after-load 'info
               (info-initialize)
               (dolist (path ',(delete-dups info-dirs))
                 (add-to-list 'Info-directory-list path))))))
     (add-hook 'doom-startup-functions #'doom--startup-loaddefs-packages 70))))

(defun doom-profile--generate-module-loader (_profile)
  (doom-file-write
   "80-doom-modules.init.el"
   (let* ((init-modules-list (doom-module-list nil t))
          (config-modules-list (doom-module-list))
          (pre-init-modules
           (seq-filter (fn! (<= (car (doom-module-get % :depth)) -100))
                       (remove '(:user . nil) init-modules-list)))
          (init-modules
           (seq-filter (fn! (<= 0 (car (doom-module-get % :depth)) 100))
                       init-modules-list))
          (config-modules
           (seq-filter (fn! (<= 0 (cdr (doom-module-get % :depth)) 100))
                       config-modules-list))
          (post-config-modules
           (seq-filter (fn! (>= (cdr (doom-module-get % :depth)) 100))
                       config-modules-list))
          (init-file   doom-module-init-file)
          (config-file doom-module-config-file))
     (letf! ((defun module-loader (key file)
               (when (and (file-exists-p file)
                          (doom-file-cookie-p file "if" t))
                 `(with-doom-module ',key
                    (doom-load ,(abbreviate-file-name
                                 (file-name-sans-extension file))))))
             (defun module-list-loader (modules file)
               (cl-loop for key in modules
                        if (or (doom-module-expand-path key file)
                               (doom-module-locate-path key file))
                        collect (module-loader key it))))
       ;; FIX: Same as above (see `doom-profile--generate-init-vars').
       `((set 'doom-modules ',doom-modules)
         (set 'doom-disabled-packages ',doom-disabled-packages)
         (static-unless noninteractive
           ;; Cache module state and flags in symbol plists for quick lookup by
           ;; `modulep!' later.
           ,@(cl-loop
              for (category . modules) in (seq-group-by #'car config-modules-list)
              collect
              `(setplist ',category
                (quote ,(cl-loop for (_ . module) in modules
                                 nconc `(,module ,(doom-module->context (cons category module))))))))
         (defun doom--startup-modules (_profile)
           (with-doom-context 'module
             (let ((old-custom-file custom-file))
               (with-doom-context 'init
                 ,@(module-list-loader pre-init-modules init-file)
                 (doom-run-hooks 'doom-before-modules-init-hook)
                 ,@(module-list-loader init-modules init-file)
                 (doom-run-hooks 'doom-after-modules-init-hook))
               (with-doom-context 'config
                 (doom-run-hooks 'doom-before-modules-config-hook)
                 ,@(module-list-loader config-modules config-file)
                 (doom-run-hooks 'doom-after-modules-config-hook)
                 ,@(module-list-loader post-config-modules config-file))
               (when (eq custom-file old-custom-file)
                 (doom-load custom-file 'noerror)))))
         (add-hook 'doom-startup-functions #'doom--startup-modules 80))))))

(provide 'doom-profiles)
;;; doom-profiles.el ends here
