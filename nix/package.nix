{
  writeShellApplication,
  git,
  emacsWithDoom,
  ripgrep,
  coreutils,
  fd,
  clang,
  gnupg,
  pinentry-emacs,
  claude-agent-acp,
  codex-acp,
}:
emacsWithDoom {
  doomDir = ../.doom.d;
  doomLocalDir = "~/.local/share/nix-doom";

  experimentalFetchTree = true;

  extraBinPackages = [
    git
    ripgrep
    coreutils
    fd
    clang
    gnupg
    pinentry-emacs

    claude-agent-acp
    codex-acp
  ];
}
