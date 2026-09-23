{
  bubblewrap,
  buildNpmPackage,
  callPackage,
  clang,
  claude-agent-acp,
  coreutils,
  emacsWithDoom,
  fd,
  fetchFromGitHub,
  ghostscript,
  git,
  gnupg,
  graphviz,
  ispell,
  pass-wayland,
  passt,
  pi-acp,
  pinentry-all,
  ripgrep,
  texliveFull,
}:
let
  codex-acp-agentclientprotocol = buildNpmPackage (finalAttrs: {
    name = "codex-acp";
    version = "1.1.5";

    src = fetchFromGitHub {
      owner = "agentclientprotocol";
      repo = "codex-acp";
      tag = "v${finalAttrs.version}";
      hash = "sha256-5vB/TxxS25F5OPh39Z+6Ofr8Xqdu4gQpwEhMWE1+DiQ=";
    };

    npmDepsHash = "sha256-AJ76gUBYuxMrSpnTI0ix9SOBRv4Q/pcTUNdPYnIWRIM=";
  });

  piAcpCustomized = callPackage ./pi-acp.nix { inherit pi-acp; };
in
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
    pinentry-all

    passt
    bubblewrap

    claude-agent-acp
    codex-acp-agentclientprotocol
    piAcpCustomized

    pass-wayland

    ispell
    ghostscript
    texliveFull
    graphviz
  ];
}
