{
  pi-coding-agent,
  writeShellApplication,
  buildNpmPackage,
  pi-acp,
}:
let
  pi-acp-pkg = buildNpmPackage (_finalAttrs: {
    name = "pi-acp";
    version = "0.0.31";

    src = pi-acp;

    npmDepsHash = "sha256-/fX79XucKojL/6gZbK5eizEfrXso8rlTgiHfJffmDuY=";
  });
in
writeShellApplication {
  name = "pi-acp";

  runtimeInputs = [
    pi-coding-agent
    pi-acp-pkg
  ];

  text = ''
    exec pi-acp "$@"
  '';
}
