{
  mkShellNoCC,
  git,
  emacsWithDoom,
  ripgrep,
  coreutils,
  fd,
  clang,
  gnupg,
  pinentry-emacs,
}:
mkShellNoCC {
  packages = [
    git
    (emacsWithDoom {
      doomDir = ../.doom.d;
      doomLocalDir = "~/.local/share/nix-doom";
      experimentalFetchTree = true;
    })
    ripgrep
    coreutils
    fd
    clang
    gnupg
    pinentry-emacs
  ];
}
