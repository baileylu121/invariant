;;; tramp-bwrap.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026
;;
;; Author:  <luke@invariant>
;; Maintainer:  <luke@invariant>
;; Created: July 28, 2026
;; Modified: July 28, 2026
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/baileylu121/nix-doom-emacs
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;; Simple bwrap wrapper for using it as a sandbox over tramp
;;
;;; Description
;; Constructs a bwrap invocation via shell and launches it, giving you read only access
;; to the rest of the filesystem, read write access to the dir you open, and hiding the
;; rest of $HOME entirely.  Runs under pasta in its own network namespace so each
;; sandbox gets an independent port space.
;;
;;; Code:

(defvar tramp-methods)

(defun tramp-bwrap--host (dir)
  "Calculate the host part of the tramp schema based on the `DIR` path from `$HOME`."
  (let* ((home (directory-file-name (expand-file-name "~")))
         (dir (directory-file-name (expand-file-name dir))))
    (unless (string-prefix-p (concat home "/") dir)
      (user-error "Error: tramp-bwrap %s is not under %s" dir home))
    (replace-regexp-in-string "/" "%" (substring dir (1+ (length home))))))

(defconst tramp-bwrap--bwrap-path
  (or (executable-find "bwrap")
      (user-error "Error: tramp-bwrap could not locate bwrap on $PATH"))
  "Absolute path to the bwrap executable, resolved once at load time.")

(defconst tramp-bwrap--pasta-path
  (or (executable-find "pasta")
      (user-error "Error: tramp-bwrap could not locate pasta on $PATH"))
  "Absolute path to the pasta executable, resolved once at load time.")

(defconst tramp-bwrap--login-script
  ;; TRAMP joins `tramp-login-args' groups with spaces and feeds the
  ;; result as literal input to an already-running login shell, so this
  ;; whole script must come out as a single shell-quoted word, else the
  ;; login shell splits it apart at the first unquoted `;'.
  (replace-regexp-in-string
   "%" "%%"
   (shell-quote-argument
    (concat
     "dir=\"$HOME/$(printf '%s' \"$1\" | tr '%' '/')\"; "
     "shift; "
     "exec " tramp-bwrap--pasta-path " -t none -u none --config-net -- " tramp-bwrap--bwrap-path " "
     "--ro-bind / / "
     "--tmpfs \"$HOME\" "
     "--bind \"$dir\" \"$dir\" "
     "--bind-try \"$HOME/.claude\" \"$HOME/.claude\" "
     "--bind-try \"$HOME/.claude.json\" \"$HOME/.claude.json\" "
     "--bind-try \"$HOME/.pi\" \"$HOME/.pi\" "
     "--bind-try \"$HOME/.codex\" \"$HOME/.codex\" "
     "--bind-try /nix/var/nix/daemon-socket/socket /nix/var/nix/daemon-socket/socket "
     "--chdir \"$dir\" "
     "--proc /proc --dev /dev --tmpfs /tmp "
     "--unshare-pid --unshare-uts --unshare-ipc --die-with-parent --new-session "
     "$@")))
  "Shell script run by the \"bwrap\" TRAMP method.")

(defun tramp-bwrap--install ()
  "Register the \"bwrap\" TRAMP method."
  (require 'tramp)
  (add-to-list 'tramp-methods
               `("bwrap"
                 (tramp-login-program "sh")
                 (tramp-login-args
                  (("-c") (,tramp-bwrap--login-script) ("bwrap-agent") ("%h") ("%l")))
                 (tramp-remote-shell "/bin/sh")
                 (tramp-remote-shell-login ("-l"))
                 (tramp-remote-shell-args ("-c")))))

(with-eval-after-load 'tramp
  (tramp-bwrap--install))

;;;###autoload
(defun tramp-bwrap-find-file (dir)
  "Wrap a `DIR` in $HOME with pasta and bwrap."
  (interactive "DSandbox directory (writable, under HOME): ")
  (require 'tramp)
  (let* ((dir (directory-file-name (expand-file-name dir)))
         (host (tramp-bwrap--host dir)))
    (find-file (format "/bwrap:%s:%s/" host dir))))

(provide 'tramp-bwrap)
;;; tramp-bwrap.el ends here
