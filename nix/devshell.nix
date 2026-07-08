{
  mkShellNoCC,
  git,
  emacsWithDoom,
  ripgrep,
  coreutils,
  fd,
  clang,
}:
mkShellNoCC {
  packages = [
    git
    (emacsWithDoom {
      doomDir = ../.doom.d;
      doomLocalDir = "~/.local/share/nix-doom";
    })
    ripgrep
    coreutils
    fd
    clang
  ];
}
