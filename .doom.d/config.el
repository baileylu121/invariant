;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Compline theme
(load! "themes/compline-theme")
(setq doom-theme 'compline)

;; Relative line numbers
(setq display-line-numbers-type 'visual)

;; Additional keybinds for built ins
(map! :leader
      (:prefix ("l" . "locate")
       :desc "Consult ripgrep" "r" #'consult-ripgrep
       :desc "Consult fd" "f" #'consult-fd
       ))

;; Org mode config
(setq org-directory "~/org/")

;; RSS reader
(after! elfeed-org (setq rmh-elfeed-org-files (list "~/org/elfeed.org")))

;; `agent-shell` config

(use-package! agent-shell
  :defer t
  :init
  (setq agent-shell-anthropic-claude-acp-command (list (executable-find "claude-agent-acp")))
  (setq agent-shell-openai-codex-acp-command (list (executable-find "codex-acp")))
  (setq agent-shell-pi-acp-command (list (executable-find "pi-acp")))
  (setq agent-shell-session-restore-verbosity 'full)
  (map! :leader
        (:prefix ("e" . "agent shell")
         :desc "Agent Shell: New Shell" "e" #'agent-shell-new-shell
         :desc "Agent Shell: New Pi Shell" "p" #'agent-shell-pi-start-agent
         :desc "Agent Shell: New Codex Shell" "x" #'agent-shell-openai-start-codex
         :desc "Agent Shell: New Claude Shell" "c" #'agent-shell-anthropic-start-claude-code
         ))
  )

(use-package! agent-shell-tramp
  :after agent-shell
  :config
  (load! "tramp-bwrap.el")
  (agent-shell-tramp-mode 1))

;; Password sourcing
(require 'auth-source-pass)
(auth-source-pass-enable)

;; Linear emacs
(defun linear-load-api-key-from-auth-source ()
  "Load Linear API key from auth-source."
  (interactive)
  (require 'auth-source)
  (let* ((auth-info (auth-source-search :host "api.linear.app" :user "apikey" :max 1))
         (secret (when auth-info
                   (funcall (plist-get (car auth-info) :secret)))))
    (if secret
        (progn
          (setq linear-emacs-api-key secret)
          (message "Successfully loaded Linear API key from auth-source"))
      (message "Failed to retrieve Linear API key from auth-source"))))

(use-package! linear-emacs
  :commands (linear-emacs-list-issues
             linear-emacs-new-issue
             linear-emacs-enable-org-sync)
  :config (linear-load-api-key-from-auth-source))
