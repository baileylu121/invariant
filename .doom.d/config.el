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
(require 'acp)
(require 'agent-shell)

(setq agent-shell-anthropic-claude-acp-command (list (executable-find "claude-agent-acp")))
(setq agent-shell-openai-codex-acp-command (list (executable-find "codex-acp")))

(setq agent-shell-session-restore-verbosity 'full)
