_:
let
  direnvVersion = "2025.1211.9";
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.opencode-direnv-plugin = pkgs.stdenv.mkDerivation {
        pname = "opencode-direnv";
        version = direnvVersion;

        src = pkgs.fetchFromGitHub {
          owner = "simonwjackson";
          repo = "opencode-direnv";
          rev = "v${direnvVersion}";
          hash = "sha256-5fmyNIQjF5v8TYWRsGMtaWCj9KxoQimX5/XTUcl65kU=";
        };

        nativeBuildInputs = [ pkgs.bun ];

        buildPhase = ''
          bun build src/index.ts \
            --outdir dist \
            --target bun \
            --format esm \
            --external @opencode-ai/plugin
        '';

        installPhase = ''
          mkdir -p "$out/lib/node_modules/@simonwjackson/opencode-direnv"
          cp -r dist package.json "$out/lib/node_modules/@simonwjackson/opencode-direnv/"
        '';
      };
    };
}
