{
  bubblewrap,
  callPackage,
  clang,
  coreutils,
  emacsWithDoom,
  fd,
  ghostscript,
  git,
  gnupg,
  graphviz,
  ispell,
  pass-wayland,
  passt,
  pi-acp,
  pinentry-all,
  poppler-utils,
  ripgrep,
  texliveFull,

  llm-agents,
  stdenv,
}:
let
  piAcpCustomized = callPackage ./_pi-acp.nix { inherit pi-acp; };
in
emacsWithDoom {
  doomDir = ./_doom.d;
  doomLocalDir = "~/.local/share/nix-doom";

  experimentalFetchTree = true;

  extraBinPackages = [
    git
    ripgrep
    coreutils
    fd
    clang
    gnupg
    pinentry-all

    passt
    bubblewrap

    llm-agents.packages.${stdenv.hostPlatform.system}.claude-agent-acp
    llm-agents.packages.${stdenv.hostPlatform.system}.omp
    llm-agents.packages.${stdenv.hostPlatform.system}.codex-acp
    piAcpCustomized

    pass-wayland

    ispell
    ghostscript
    texliveFull
    graphviz
    poppler-utils
  ];
}
