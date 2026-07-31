;;; $DOOMDIR/packages.el -*- lexical-binding: t; no-byte-compile: t -*-

;; `agent-shell` and it's dependencies
(package! shell-maker)
(package! acp)
(package! agent-shell)

(package! agent-shell-tramp
  :recipe (:host github :repo "junyi-hou/agent-shell-tramp")
  :pin "14560d42440c17d9b59fc18d304687641ddf06e5")

;; TODO: temp pin since current build breaks
(package! ghostel
  :recipe (:host github :repo "dakra/ghostel")
  :pin "f87c7ee794c34d4e100b229d49f07b89d0fec840")
