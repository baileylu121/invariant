{
  pi-coding-agent,
  writeShellApplication,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
let
  pi-acp = buildNpmPackage (finalAttrs: {
    name = "pi-acp";
    version = "0.0.31";

    src = fetchFromGitHub {
      owner = "svkozak";
      repo = "pi-acp";
      tag = "v${finalAttrs.version}";
      hash = "sha256-bM3V/3fxkY2Ib+OyfT82StIIRSLXGDuYUbt1CZKpTuo=";
    };

    npmDepsHash = "sha256-qN+b/tMbnJLkWjotl3XrA0nfZ3KT/mT6gM+n3Qiz8Wk=";
  });
in
writeShellApplication {
  name = "pi-acp";

  runtimeInputs = [
    pi-coding-agent
    pi-acp
  ];

  runtimeEnv = {
    PI_CODING_AGENT_DIR = ../pi;
  };

  text = ''
    export PI_CODING_AGENT_SESSION_DIR="$HOME/.pi/agent/sessions";

    exec pi-acp "$@"
  '';
}
