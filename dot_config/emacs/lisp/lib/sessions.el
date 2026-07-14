;;; lisp/lib/sessions.el -*- lexical-binding: t; -*-

;;
;;; * Helpers

;;;###autoload
(defun doom-session-file (&optional name)
  "TODO"
  (cond ((require 'persp-mode nil t)
         (expand-file-name (or name persp-auto-save-fname) persp-save-dir))
        ((require 'desktop nil t)
         (if name
             (expand-file-name name (file-name-directory (desktop-full-file-name)))
           (desktop-full-file-name)))
        ((error "No session backend available"))))

;;;###autoload
(defun doom-save-session (&optional file)
  "TODO"
  (setq file (expand-file-name (or file (doom-session-file))))
  (cond ((require 'persp-mode nil t)
         (unless persp-mode (persp-mode +1))
         (setq persp-auto-save-opt 0)
         (persp-save-state-to-file file))
        ((and (require 'frameset nil t)
              (require 'desktop nil t))
         (dlet ((desktop-base-file-name (file-name-nondirectory file))
                (desktop-dirname (file-name-directory file))
                (desktop-restore-eager t)
                (desktop-file-modtime nil))
           (make-directory desktop-dirname t)
           ;; Prevents confirmation prompts
           (dlet ((desktop-file-modtime
                   (file-attribute-modification-time
                    (file-attributes (desktop-full-file-name)))))
             (desktop-save desktop-dirname))))
        ((error "No session backend to save session with"))))

;;;###autoload
(defun doom-load-session (&optional file)
  "TODO"
  (setq file (expand-file-name (or file (doom-session-file))))
  (message "Attempting to load %s" file)
  (cond ((not (file-readable-p file))
         (message "No session file at %S to read from" file))
        ((require 'persp-mode nil t)
         (unless persp-mode
           (persp-mode +1))
         (cl-loop with allowed = (persp-list-persp-names-in-file file)
                  for name being the hash-keys of *persp-hash*
                  unless (member name allowed)
                  do (persp-kill name))
         (persp-load-state-from-file file))
        ((and (require 'frameset nil t)
              (require 'desktop nil t))
         (dlet ((desktop-file-modtime nil)
                (desktop-dirname (file-name-directory file))
                (desktop-base-file-name (file-name-nondirectory file))
                (desktop-base-lock-name (concat (file-name-nondirectory file) ".lock"))
                (desktop-restore-reuses-frames nil)
                ;; Disable prompts for safe variables during restoration
                (enable-local-variables :safe))
           (if (daemonp)
               (letf! ((#'display-color-p #'always)
                       (#'display-graphic-p #'always))
                 (desktop-read desktop-dirname))
             (desktop-read desktop-dirname))))
        ((error "No session backend to load session with"))))


;;
;;; * Commands

;;;###autoload
(defun doom/quickload-session (force)
  "Load the last session saved.
If the FORCE \\[universal-argument] is provided
then no confirmation is asked."
  (interactive "P")
  (if (or force
          (yes-or-no-p "This will wipe your current session, do you want to continue? "))
      (progn (message "Restoring session...")
             (doom-load-session)
             (message "Session restored. Welcome back."))
    (message "Session not restored.")))

;;;###autoload
(defun doom/quicksave-session ()
  "TODO"
  (interactive)
  (message "Saving session")
  (doom-save-session)
  (message "Saving session...DONE"))

;;;###autoload
(defun doom/load-session (file)
  "TODO"
  (interactive
   (let ((session-file (doom-session-file)))
     (list (or (read-file-name "Session to restore: "
                               (file-name-directory session-file)
                               (file-name-nondirectory session-file)
                               t)
               (user-error "No session selected. Aborting")))))
  (unless file
    (error "No session file selected"))
  (message "Loading '%s' session" file)
  (doom-load-session file)
  (message "Session restored. Welcome back."))

;;;###autoload
(defun doom/save-session (file)
  "TODO"
  (interactive
   (let ((session-file (doom-session-file)))
     (list (or (read-file-name "Save session to: "
                               (file-name-directory session-file)
                               (file-name-nondirectory session-file))
               (user-error "No session selected. Aborting")))))
  (unless file
    (error "No session file selected"))
  (message "Saving '%s' session" file)
  (doom-save-session file))

;;;###autoload
(defun doom/restart ()
  "Restart Emacs (and the daemon, if active).

Unlike `doom/restart-and-restore', does not restart the current session."
  (interactive)
  (unless (fboundp 'restart-emacs)
    (user-error "Cannot restart Emacs 28 or older"))
  (restart-emacs))

(provide 'doom-lib '(sessions))
;;; sessions.el ends here
