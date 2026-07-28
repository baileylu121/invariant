;;; $DOOMDIR/packages.el -*- lexical-binding: t; no-byte-compile: t -*-

;; `agent-shell` and it's dependencies
(package! shell-maker)
(package! acp)
(package! agent-shell)

(package! agent-shell-tramp
  :recipe (:host github :repo "junyi-hou/agent-shell-tramp")
  :pin "14560d42440c17d9b59fc18d304687641ddf06e5")
