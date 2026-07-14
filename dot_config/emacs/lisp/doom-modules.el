;;; lisp/doom-modules.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;;
;;; * Variables

;;;###autoload
(defvar doom-modules nil
  "A table of enabled modules and metadata. See `doom-modules-initialize'.")

(make-obsolete-variable 'doom-inhibit-module-warnings nil "2.1.0")
(defvar doom-inhibit-module-warnings (not noninteractive)
  "If non-nil, don't emit deprecated or missing module warnings at startup.")

;;;###autoload
(defvar doom-module-init-file "init.el"
  "The filename for module early initialization config files.

Init files are loaded early, just after Doom core, and before modules' config
files. They are always loaded, even in non-interactive sessions, and before
`doom-before-modules-init-hook'. Related to `doom-module-config-file'.")

;;;###autoload
(defvar doom-module-config-file "config.el"
  "The filename for module configuration files.

Config files are loaded later, and almost always in interactive sessions. These
run before `doom-after-modules-config-hook' and after `doom-module-init-file'.")

;;;###autoload
(defvar doom-module-packages-file "packages.el"
  "The filename for the package configuration file.

Package files are read whenever Doom's package manager wants a manifest of all
desired packages. They are rarely read in interactive sessions (unless the user
uses a straight or package.el command directly).")

;;;###autoload
(defvar doom-module-cli-file "cli.el"
  "The CLI configuration filename.")


;;
;;; * Library

;;; ** Bootstrapper

(defun doom-modules-initialize (&optional force?)
  "Initializes module metadata."
  (when (or (null doom-modules) force?)
    (setq doom-modules (make-hash-table :test 'equal))
    ;; Register Doom's two virtual module categories, representing Doom's core
    ;; and the user's config; which are always enabled.
    (doom-module--put '(:doom . nil)
                      :depth -110)
    (doom-module--put '(:user . nil)
                      :path doom-user-dir
                      :depth '(-105 . 105))
    ;; DEPRECATED: Includes use-package, deprecated APIs/vars, smartparens,
    ;;   projectile -- everything that makes v2 distinct from v3. The module is
    ;;   here to stay, but it won't be hardcoded after v3.
    (doom-module--put '(:doom . compat)
                      :flags '(+keybinds +better-jumper +projectile +smartparens)
                      :depth -115)
    ;; Load $DOOMDIR/init.el, where the user's `doom!' lives, which will inform
    ;; us of all desired modules.
    (doom-load (doom-user-dir doom-module-init-file)
               'noerror)))

(cl-defun doom-module--put ((group . name) &rest plist)
  "Enable GROUP NAME and associate PLIST with it.

This enables the target module, where GROUP is a keyword, NAME is a symbol, and
PLIST is a property list accepting none, any, or all of the following
properties:

  :group KEYWORD
    Indicating the group this module is in. This doesn't have to match GROUP, as
    it could indicate a module alias.
  :name SYMBOL
    Indicating the name of this module. This doesn't have to match NAME, as it
    could indicate a module alias.
  :path STRING
    Path to the directory where this module lives.
  :depth INT|(INITDEPTH . CONFIGDEPTH)
    Determines module load order. If a cons cell, INITDEPTH determines the load
    order of the module's init.el, while CONFIGDEPTH determines the same for all
    other config files (config.el, packages.el, doctor.el, etc).
  :flags (SYMBOL...)
    A list of activated flags for this module. Will be collapsed into
    pre-existing flags for the module.
  :features (SYMBOL...)
    A list of active features, determined from the module's metadata. Will be
    collapsed into any pre-existing features for the module. NOT IMPLEMENTED
    YET.

\(fn (GROUP . NAME) &key GROUP NAME PATH DEPTH FLAGS FEATURES)"
  (let ((module
         (make-doom-module
          :index (hash-table-count doom-modules)
          :group (or (plist-get plist :group) group)
          :name  (or (plist-get plist :name) name)
          :path  (or (plist-get plist :path)
                     (doom-module-locate-path (cons group name)))
          :flags (plist-get plist :flags)
          :features ()  ; TODO
          :depth
          (if (not (plist-member plist :depth))
              '(0 . 0)
            (let ((depth (plist-get plist :depth)))
              (cl-check-type depth (or integer cons))
              (cond ((integerp depth) (cons depth depth))
                    ((consp depth) (cons (or (car depth) 0)
                                         (or (cdr depth) 0)))
                    ((signal 'wrong-type-argument `((or integer cons) ,depth)))))))))
    (doom-log 2 "module-put: %s" module)
    (prog1 (puthash (cons group name) module doom-modules)
      ;; PERF: Doom caches module index, flags, and features in symbol plists
      ;;   for fast lookups in `modulep!' and elsewhere. plists are lighter and
      ;;   faster than hash tables for datasets this size, and this information
      ;;   is looked up *very* often.
      (put group name (doom-module->context module)))))

(defun doom-module--remap (group module)
  (cl-loop for (old new v) in
           (with-memoization (get 'doom-module--remap 'cache)
             (cl-loop for dir in (reverse doom-module-load-path)
                      if (doom-config `(,dir modules obsolete))
                      append it))
           if (equal `(,group ,module) old)
           return (list old new v)))

(defun doom-module-mplist-map (fn mplist)
  "Apply FN to each module in MPLIST."
  (let ((mplist (copy-sequence mplist))
        (inhibit-message doom-inhibit-module-warnings)
        results
        group m)
    (while mplist
      (setq m (pop mplist))
      (cond ((keywordp m)
             (setq group m))
            ((null group)
             (signal 'doom-user-error `(no-module-group-for ,m)))
            ((and (listp m) (keywordp (car m)))
             (pcase (car m)
               (:cond
                (cl-loop for (cond . mods) in (cdr m)
                         if (eval cond t)
                         return (cl-callf2 append mods mplist)))
               (:if (if (eval (cadr m) t)
                        (push (caddr m) mplist)
                      (cl-callf2 append (cdddr m) mplist)))
               (test (if (xor (eval (cadr m) t)
                              (eq test :unless))
                         (cl-callf2 append (cddr m) mplist)))))
            ((catch 'doom-modules
               (let* ((module (if (listp m) (car m) m))
                      (flags  (if (listp m) (cdr m))))
                 (when-let* ((remap (doom-module--remap group module)))
                   (pcase-let* ((`(,old ,new ,when) remap))
                     (when when
                       (setq when (format " in %s" when)))
                     (if (null new)
                         (print! (warn "%s module was removed%s, ignoring..." old when))
                       (if (stringp new)
                           (print! (warn "%s module was removed%s: %s..." old new when))
                         (print! (warn "%s module was moved to %s%s, remapping..." old new when)))
                       (push group mplist)
                       (dolist (f (reverse new))
                         (push (if (keywordp f) f (cons f flags))
                               mplist))
                       (throw 'doom-modules t))))
                 (push (funcall fn (cons group module) :flags (if (listp m) (cdr m)))
                       results))))))
    (when noninteractive
      (setq doom-inhibit-module-warnings t))
    (nreverse results)))


;;; ** doom-module

;;;###autoload
(eval-and-compile
  (cl-defstruct doom-module
    "TODO"
    (index 0 :read-only t)
    ;; source
    group
    name
    depth
    flags
    features
    ;; sources
    path
    ;; disabled-p
    ;; frozen-p
    ;; layer-p
    ;; recipe
    ;; alist
    ;; package
    ;; if
    )

  (pcase-defmacro doom-module (&rest fields)
    `(doom-struct doom-module ,@fields))

  (defun doom-module-key (key)
    "Normalize KEY into a (GROUP . MODULE) tuple representing a Doom module key."
    (declare (pure t) (side-effect-free t))
    (cond ((doom-module-p key)
           (cons (doom-module-group key) (doom-module-name key)))
          ((doom-module-context-p key)
           (doom-module-context-key key))
          ((car-safe key)
           (if (nlistp (cdr-safe key))
               key
             (cons (car key) (cadr key))))
          ((signal 'wrong-type-argument
                   `((or doom-module doom-module-context cons) ,key)))))

  (defun doom-module--has-flag-p (flags wanted-flags)
    "Return t if the list of WANTED-FLAGS satisfies the list of FLAGS."
    (declare (pure t) (side-effect-free error-free))
    (cl-loop with flags = (ensure-list flags)
             for flag in (ensure-list wanted-flags)
             for flagstr = (symbol-name flag)
             if (if (eq ?- (aref flagstr 0))
                    (memq (intern (concat "+" (substring flagstr 1)))
                          flags)
                  (not (memq flag flags)))
             return nil
             finally return t))

  (defun doom-module--fold-flags (flags)
    "Returns a collapsed list of FLAGS (a list of +/- prefixed symbols).

FLAGS is read in sequence, cancelling out negated flags and removing
duplicates."
    (declare (pure t) (side-effect-free error-free))
    (let (newflags)
      (while flags
        (let* ((flag (car flags))
               (flagstr (symbol-name flag)))
          (when-let* ((sym (intern-soft
                            (concat (if (eq ?- (aref flagstr 0)) "+" "-")
                                    (substring flagstr 1)))))
            (setq newflags (delq sym newflags)))
          (cl-pushnew flag newflags :test 'eq))
        (setq flags (cdr flags)))
      (nreverse newflags)))

  (cl-defun doom-module--depth< (keya keyb &optional initorder?)
    "Return t if module with KEY-A comes before another with KEY-B.

If INITORDER? is non-nil, grab the car of the module's :depth, rather than it's
cdr. See `doom-module-put' for details about the :depth property."
    (declare (pure t) (side-effect-free t))
    (let* ((adepth (doom-module-get keya :depth))
           (bdepth (doom-module-get keyb :depth))
           (adepth (if initorder? (car adepth) (cdr adepth)))
           (bdepth (if initorder? (car bdepth) (cdr bdepth))))
      (if (or (null adepth) (null bdepth)
              (= adepth bdepth))
          (< (or (doom-module-get keya :index) 0)
             (or (doom-module-get keyb :index) 0))
        (< adepth bdepth))))

  (defun doom-module-get (key &optional property)
    "Returns the plist for GROUP MODULE. Gets PROPERTY, specifically, if set."
    (declare (side-effect-free t))
    (when-let* ((m (gethash key doom-modules)))
      (if property
          (aref
           m (or (plist-get
                  (eval-when-compile
                    (cl-loop with i = 1
                             for info in (cdr (cl-struct-slot-info 'doom-module))
                             nconc (list (doom-keyword-intern (symbol-name (car info)))
                                         (prog1 i (cl-incf i)))))
                  property)
                 (signal 'doom-core-error `(invalid-module-property ,property))))
        m)))

  (defun doom-module-active-p (group module &optional flags)
    "Return t if GROUP MODULE is active, and with FLAGS (if given)."
    (declare (side-effect-free t))
    (when-let* ((val (doom-module-get (cons group module) (if flags :flags))))
      (or (null flags)
          (doom-module--has-flag-p flags val))))

  (defun doom-module-exists-p (group module)
    "Returns t if GROUP MODULE is present in any active source."
    (declare (side-effect-free t))
    (if (doom-module-get group module) t))

  (cl-defun doom-module--depth< (keya keyb &optional initorder?)
    "Return t if module with KEY-A comes before another with KEY-B.

If INITORDER? is non-nil, grab the car of the module's :depth, rather than it's
cdr. See `doom-module-put' for details about the :depth property."
    (declare (pure t) (side-effect-free t))
    (let* ((adepth (doom-module-get keya :depth))
           (bdepth (doom-module-get keyb :depth))
           (adepth (if initorder? (car adepth) (cdr adepth)))
           (bdepth (if initorder? (car bdepth) (cdr bdepth))))
      (if (or (null adepth) (null bdepth)
              (= adepth bdepth))
          (< (or (doom-module-get keya :index) 0)
             (or (doom-module-get keyb :index) 0))
        (< adepth bdepth))))

  (defun doom-module-list (&optional paths-or-all initorder?)
    "Return a list of (:group . name) module keys in order of their :depth.

PATHS-OR-ALL can either be a non-nil value or a list of directories. If given a
list of directories, return a list of module keys for all modules present
underneath it.  If non-nil, return the same, but search `doom-module-load-path'
(includes :doom and :user). Modules that are enabled are sorted first by their
:depth, followed by disabled modules in lexicographical order (unless a :depth
is specified in their .doommodule).

If INITORDER? is non-nil, sort modules by the CAR of that module's :depth."
    (sort (if paths-or-all
              (delete-dups
               (append (seq-remove #'cdr (doom-module-list nil initorder?))
                       (doom-files-in (if (listp paths-or-all)
                                          paths-or-all
                                        doom-module-load-path)
                                      :map #'doom-module-from-path
                                      :type 'dirs
                                      :mindepth 1
                                      :depth 1)))
            (hash-table-keys doom-modules))
          (doom-rpartial #'doom-module--depth< initorder?)))

  (defun doom-module-expand-path (key &optional file)
    "Expands a path to FILE relative to KEY, a cons cell: (GROUP . NAME)

GROUP is a keyword. MODULE is a symbol. FILE is an optional string path.
If the group isn't enabled this returns nil. For finding disabled modules use
`doom-module-locate-path' instead."
    (when-let* ((path (doom-module-get key :path)))
      (if file
          (file-name-concat path file)
        path)))

  (defun doom-module-locate-path (key &optional file)
    "Searches `doom-module-load-path' to find the path to a module by KEY.

KEY is a cons cell (GROUP . NAME), where GROUP is a keyword (e.g. :lang) and
NAME is a symbol (e.g. \\='python). FILE is a string that will be appended to
the resulting path. If said path doesn't exist, this returns nil, otherwise an
absolute path."
    (let (file-name-handler-alist)
      (cl-destructuring-bind (group . module) (doom-module-key key)
        (when-let*
            ((default-directory
              (if (equal (cons group module) '(:user))
                  (doom-module-expand-path key)
                (cl-loop with group = (doom-keyword-name group)
                         with module = (if module (symbol-name module))
                         with dir = (file-name-concat group module)
                         for default-directory in doom-module-load-path
                         if (file-directory-p dir)
                         return (expand-file-name dir)))))
          (if file
              (when (file-exists-p file)
                (expand-file-name file))
            default-directory)))))

  (defun doom-module-locate-paths (module-list file)
    "Return all existing paths to FILE under each module in MODULE-LIST.

MODULE-LIST is a list of cons cells (GROUP . NAME). See `doom-module-list' for
an example."
    (cl-loop for key in (or module-list (doom-module-list))
             if (doom-module-locate-path key file)
             collect it))

  (defvar doom-module--path-cache (make-hash-table :test 'equal))
  (defun doom-module-from-path (path &optional nocache?)
    "Returns a cons cell (GROUP . NAME) derived from PATH (a file path).
If ENABLED-ONLY?, return nil if the containing module isn't enabled."
    (let* ((file-name-handler-alist nil)
           (dir (or (doom-config-locate 'module path t) ; look for .doommodule
                    ;; PERF: Module autoload files (using `modulep!') are this
                    ;;   function's primary consumer, because I can't
                    ;;   non-trivially inject `doom-module-context' into Emacs'
                    ;;   autoloader. For performance's sake, I'll take some
                    ;;   shortcuts for them. Plus, 'doom sync' will seed the
                    ;;   module path cache.
                    (save-match-data
                      (if (or (string-match "^\\(.+/\\)autoload\\.el$" path)
                              (string-match "^\\(.+/\\)autoload/[^/]+\\.el$" path))
                          (expand-file-name (match-string 1 path))))
                    ;; FIXME: Ew. Necessary, in case of strange symlinking.
                    ;;   This will be cleaned up in v3.
                    (catch 'found
                      (dolist (dir (remq
                                    nil (cons (doom-config-locate 'modules path t)
                                              doom-module-load-path)))
                        (when (file-in-directory-p path dir)
                          (let ((relpath (file-relative-name (file-truename path)
                                                             (file-truename dir))))
                            (unless (string-match-p "\\.\\." relpath)
                              (throw 'found
                                     (apply #'file-name-concat dir
                                            (seq-take (split-string relpath "/" t) 2))))))))))
           (module? (and dir t)))
      (unless dir
        (setq dir (file-name-as-directory
                   (directory-file-name (file-name-directory path)))))
      (save-match-data
        (cond
         ;; For v3+ modules
         ((if (not nocache?) (gethash (abbreviate-file-name dir) doom-module--path-cache)))

         ;; For legacy or $DOOMDIR modules
         ((string-match "/\\(?:modules/\\)+\\([^/]+\\)/\\([^/]+\\)?" dir)
          (puthash (abbreviate-file-name dir)
                   (cons (doom-keyword-intern (match-string 1 dir))
                         (ignore-errors (intern (match-string 2 dir))))
                   doom-module--path-cache))

         ;; These are last ditch hail mary's. `file-in-directory-p' can be slow,
         ;; but is the most reliable, especially in cases where the user has
         ;; weird symlink setups.
         ((if (hash-table-p doom-modules)
              (cl-loop for m being the hash-values of doom-modules
                       for mkey = (doom-module-key m)
                       if (cdr mkey)
                       if (doom-module-path m)
                       if (file-in-directory-p dir it)
                       return (puthash (abbreviate-file-name dir)
                                       mkey
                                       doom-module--path-cache))))
         ((file-in-directory-p path doom-core-dir)
          (cons :doom nil))
         ((file-in-directory-p path doom-user-dir)
          (cons :user nil))))))

  ;; DEPRECATED: Remove in v3
  (defun doom-module-load-path (&optional module-load-path initorder?)
    "Return a list of file paths to activated modules.

The list is in no particular order and its file paths are absolute.
MODULE-LOAD-PATH can be a list of module tree root directories or `t' (return
all modules in all known sources, collapsed by precedence)."
    (declare (side-effect-free t))
    (mapcar #'doom-module-locate-path (doom-module-list module-load-path initorder?))))


;;; ** doom-module-context

;;;###autoload
(eval-and-compile
  (cl-defstruct doom-module-context
    "Hot cache object for the containing Doom module."
    index key path flags features)

  (defvar doom-module-context (make-doom-module-context)
    "A `doom-module-context' for the module associated with the current file.

Never set this variable directly, use `with-doom-module'.")

  (defmacro with-doom-module (key &rest body)
    "Evaluate BODY with `doom-module-context' informed by KEY."
    (declare (indent 1))
    `(let ((doom-module-context
            (let ((key ,key))
              (if key
                  (doom-module-context key)
                (make-doom-module-context)))))
       (doom-log 3 ":context:module: =%s" doom-module-context)
       ,@body))

  (defun doom-module-context (key)
    "Return a `doom-module-context' from KEY.

KEY can be a `doom-module-context', `doom-module', or a `doom-module-key' cons
cell. Throws an error if nil."
    (declare (side-effect-free t))
    (or (cond ((doom-module-context-p key) key)
              ((doom-module-p key) (doom-module->context key))
              ((consp key) (doom-module (car key) (cdr key))))
        (make-doom-module-context :key (doom-module-key key))))

  (defun doom-module->context (key)
    "Change a `doom-module' into a `doom-module-context'."
    (declare (side-effect-free t))
    (let ((module (if (doom-module-p key)
                      key (doom-module-get (doom-module-key key)))))
      (make-doom-module-context
       :index (doom-module-index module)
       :key (cons (doom-module-group module) (doom-module-name module))
       :path (doom-module-path module)
       :flags (doom-module-flags module))))

  (defun doom-module (group name &optional property)
    "Return the `doom-module-context' for any active module by GROUP NAME.

This function accesses the hot cache for modules and should be used where
performance is important (e.g. in interactive sessions). Use `doom-module-get'
if correctness is more important (e.g. in non-interactive sessions).

Return its PROPERTY, if specified."
    (declare (side-effect-free t))
    (when-let* ((context (get group name)))
      (if property
          (aref
           context
           (or (plist-get
                (eval-when-compile
                  (cl-loop with i = 1
                           for info in (cdr (cl-struct-slot-info 'doom-module-context))
                           nconc (list (doom-keyword-intern (symbol-name (car info)))
                                       (prog1 i (cl-incf i)))))
                property)
               (signal 'doom-core-error `(invalid-module-context-property ,property))))
        context))))

;;;###autoload
(pcase-defmacro doom-module-context (&rest fields)
  `(doom-struct doom-module-context ,@fields))

;;;###autoload
(defun doom-module<-context (context)
  "Return a `doom-module' plist from CONTEXT."
  (declare (side-effect-free t))
  (doom-module-get (doom-module-context-key context)))


;;
;;; * Module DSL

;;;###autoload
(eval-and-compile
  (put :if     'lisp-indent-function 2)
  (put :when   'lisp-indent-function 'defun)
  (put :unless 'lisp-indent-function 'defun)

  (defmacro doom! (&rest modules)
    "Bootstraps DOOM Emacs and its modules.

If the first item in MODULES doesn't satisfy `keywordp', MODULES is evaluated,
otherwise, MODULES is a variadic-property list (a plist whose key may be
followed by one or more values).

This macro does nothing in interactive sessions, but in noninteractive session
iterates through MODULES, enabling and initializing them. The order of modules
in these blocks dictates their load order (unless given an explicit :depth)."
    `(when noninteractive
       ;; REVIEW: A temporary fix for flycheck until I complete backporting
       ;;   module/profile architecture from v3.0.
       (when (fboundp 'doom-module-mplist-map)
         (doom-module-mplist-map
          #'doom-module--put
          ,@(if (keywordp (car modules))
                (list (list 'quote modules))
              modules)))
       t))

  (defmacro modulep! (group &optional module &rest flags)
    "Return t if :GROUP MODULE (and +FLAGS) are enabled.

If FLAGS is provided, returns t if GROUP MODULE has all of FLAGS enabled.

  (modulep! :config default +flag)
  (modulep! :config default +flag1 +flag2 +flag3)

GROUP and MODULE may be omitted when this macro is used from a Doom module's
source (except your $DOOMDIR, which is a special module). Like so:

  (modulep! +flag3 +flag1 +flag2)
  (modulep! +flag)

FLAGS can be negated. E.g. This will return non-nil if ':tools lsp' is enabled
without `+eglot':

  (modulep! :tools lsp -eglot)

To interpolate dynamic values, use comma:

  (let ((flag '-eglot))
    (modulep! :tools lsp ,flag))

For more about modules and flags, see `doom!'."
    (if (keywordp group)
        (let ((ctxtform `(get (backquote ,group) (backquote ,module))))
          (if flags
              `(when-let* ((ctxt ,ctxtform))
                 (doom-module--has-flag-p
                  (doom-module-context-flags ctxt)
                  (backquote ,flags)))
            `(and ,ctxtform t)))
      (let ((flags (delq nil (cons group (cons module flags)))))
        (if (doom-module-context-index doom-module-context)
            `(doom-module--has-flag-p
              ',(doom-module-context-flags doom-module-context)
              (backquote ,flags))
          `(let ((file (file!)))
             (if-let* ((module (doom-module-from-path file)))
                 (doom-module--has-flag-p
                  (doom-module (car module) (cdr module) :flags)
                  (backquote ,flags))
               (signal 'doom-module-error
                       (list "Can't resolve current module for flags"
                             (backquote ,flags)
                             (abbreviate-file-name file))))))))))

(provide 'doom-modules)
;;; doom-modules.el ends here
