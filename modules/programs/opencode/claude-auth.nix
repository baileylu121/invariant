{
  perSystem =
    { pkgs, ... }:
    {
      packages.opencode-claude-auth-plugin = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "opencode-claude-auth";
        version = "v1.4.7";

        src = pkgs.fetchFromGitHub {
          owner = "griffinmartin";
          repo = "opencode-claude-auth";
          tag = finalAttrs.version;
          hash = "sha256-2tApns6XuL3hnbJMZF+aUlUZrY/xJvbDv7c646G0qug=";
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
      });
    };
}
