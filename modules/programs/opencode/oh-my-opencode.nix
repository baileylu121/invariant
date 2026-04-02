{
  inputs,
  ...
}:
let
  pluginVersion = "3.14.0";
in
{
  perSystem =
    { pkgs, ... }:
    let
      bun2nix = inputs.bun2nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      packages.oh-my-opencode-plugin = pkgs.stdenv.mkDerivation {
        pname = "oh-my-opencode";
        version = pluginVersion;

        src = pkgs.fetchFromGitHub {
          owner = "code-yeongyu";
          repo = "oh-my-openagent";
          tag = "v3.14.0";
          hash = "sha256-GRd3hWXQxSnx7s7r6QUvnXPMvUdheupBFMk4fz1eNfw=";
        };

        nativeBuildInputs = [ bun2nix.hook ];

        bunDeps = bun2nix.fetchBunDeps {
          bunNix = ../../../pkgs/oh-my-opencode/bun.nix;
          autoPatchElf = true;
          nativeBuildInputs = [ pkgs.musl ];
        };

        dontRunLifecycleScripts = true;
        dontUseBunCheck = true;

        buildPhase = ''
          bun build src/index.ts \
            --outdir dist \
            --target bun \
            --format esm \
            --external @ast-grep/napi
          bun build src/cli/index.ts \
            --outdir dist/cli \
            --target bun \
            --format esm \
            --external @ast-grep/napi
        '';

        installPhase = ''
          mkdir -p "$out/lib/node_modules/oh-my-opencode"
          cp -r dist bin package.json "$out/lib/node_modules/oh-my-opencode/"
        '';
      };
    };
}
