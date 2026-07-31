;;; $DOOMDIR/packages.el -*- lexical-binding: t; no-byte-compile: t -*-

;; `agent-shell` and it's dependencies
(package! shell-maker)
(package! acp
  :recipe (:host github :repo "xenodium/acp.el")
  :pin "a29cb161ac95f1819f34481a98666707661c5cf8")
(package! agent-shell
  :recipe (:host github :repo "xenodium/agent-shell")
  :pin "86190a1c8da80da072c713d6ad05494496603d57")

(package! agent-shell-tramp
  :recipe (:host github :repo "junyi-hou/agent-shell-tramp")
  :pin "14560d42440c17d9b59fc18d304687641ddf06e5")

;; TODO: temp pin since current build breaks
(package! ghostel
  :recipe (:host github :repo "dakra/ghostel")
  :pin "f87c7ee794c34d4e100b229d49f07b89d0fec840")
