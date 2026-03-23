_:
let
  claudeAuthVersion = "1.1.1";
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.opencode-claude-auth-plugin = pkgs.stdenv.mkDerivation {
        pname = "opencode-claude-auth";
        version = claudeAuthVersion;

        src = pkgs.fetchFromGitHub {
          owner = "griffinmartin";
          repo = "opencode-claude-auth";
          rev = "58d491a4804469da6e7a04f454ec080026d51768";
          hash = "sha256-PuK924dxAdzO9+hjZlo7slzR2dUULer1HzWDRl+atFo=";
        };

        nativeBuildInputs = [ pkgs.bun ];

        buildPhase = ''
          bun build src/index.ts \
            --outdir dist \
            --target bun \
            --format esm \
            --external @opencode-ai/plugin
          cp src/anthropic-prompt.txt dist/
        '';

        installPhase = ''
          mkdir -p "$out/lib/node_modules/opencode-claude-auth"
          cp -r dist package.json "$out/lib/node_modules/opencode-claude-auth/"
        '';
      };
    };
}
