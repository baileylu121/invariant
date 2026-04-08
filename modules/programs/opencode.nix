{
  self,
  lib,
  ...
}:
let
  expectedOpencodeSeries = "1.3";

  baseColorNames = [
    "base00"
    "base01"
    "base02"
    "base03"
    "base05"
    "base06"
    "base08"
    "base09"
    "base0A"
    "base0B"
    "base0C"
    "base0D"
    "base0E"
    "base0F"
  ];

  defaultColors = {
    base00 = "#1a1d21";
    base01 = "#22262b";
    base02 = "#1f2228";
    base03 = "#3d424a";
    base05 = "#e0dcd4";
    base06 = "#8b919a";
    base08 = "#c8beb8";
    base09 = "#ccc4b4";
    base0A = "#d4ccb4";
    base0B = "#b8c4b8";
    base0C = "#b4c0c8";
    base0D = "#b4bcc4";
    base0E = "#b4c4bc";
    base0F = "#98a4ac";
  };

  normalizeColors =
    colors:
    let
      unknown = builtins.filter (name: !(builtins.elem name baseColorNames)) (builtins.attrNames colors);
    in
    assert lib.assertMsg (
      unknown == [ ]
    ) "mkOpencode: unknown color keys: ${lib.concatStringsSep ", " unknown}";
    defaultColors // colors;

  mkOpencode =
    {
      pkgs,
      oh-my-opencode-plugin,
      claude-auth-plugin,
      direnv-plugin,
      colors ? { },
    }:
    let
      resolvedColors = normalizeColors colors;
      colorDefs = lib.genAttrs baseColorNames (name: resolvedColors.${name});

      tuiJson = pkgs.writeText "opencode-tui.json" (
        builtins.toJSON {
          "$schema" = "https://opencode.ai/tui.json";
          theme = "stylix";
        }
      );

      themeJson = pkgs.writeText "opencode-stylix-theme.json" (
        builtins.toJSON {
          "$schema" = "https://opencode.ai/theme.json";

          defs = {
            inherit (colorDefs)
              base00
              base01
              base02
              base03
              base05
              base06
              base08
              base09
              base0A
              base0B
              base0C
              base0D
              base0E
              base0F
              ;
          };

          theme = {
            primary = "base0D";
            secondary = "base0E";
            accent = "base0C";
            error = "base08";
            warning = "base0A";
            success = "base0B";
            info = "base0C";
            text = "base05";
            textMuted = "base06";
            background = "base00";
            backgroundPanel = "base01";
            backgroundElement = "base02";
            border = "base02";
            borderActive = "base03";
            borderSubtle = "base02";

            diffAdded = "base0B";
            diffRemoved = "base08";
            diffContext = "base03";
            diffHunkHeader = "base03";
            diffHighlightAdded = "base0B";
            diffHighlightRemoved = "base08";
            diffAddedBg = "base01";
            diffRemovedBg = "base01";
            diffContextBg = "base00";
            diffLineNumber = "base03";
            diffAddedLineNumberBg = "base01";
            diffRemovedLineNumberBg = "base01";

            markdownText = "base05";
            markdownHeading = "base0D";
            markdownLink = "base0E";
            markdownLinkText = "base0C";
            markdownCode = "base0B";
            markdownBlockQuote = "base03";
            markdownEmph = "base09";
            markdownStrong = "base0A";
            markdownHorizontalRule = "base03";
            markdownListItem = "base0D";
            markdownListEnumeration = "base0C";
            markdownImage = "base0E";
            markdownImageText = "base0C";
            markdownCodeBlock = "base05";

            syntaxComment = "base03";
            syntaxKeyword = "base0E";
            syntaxFunction = "base0D";
            syntaxVariable = "base0C";
            syntaxString = "base0B";
            syntaxNumber = "base0F";
            syntaxType = "base0A";
            syntaxOperator = "base0E";
            syntaxPunctuation = "base05";
          };
        }
      );

      pluginShim = pkgs.writeTextFile {
        name = "oh-my-opencode-plugin-shim.js";
        text = ''
          export { default } from "${oh-my-opencode-plugin}/lib/node_modules/oh-my-opencode/dist/index.js";
        '';
      };

      claudeAuthShim = pkgs.writeTextFile {
        name = "opencode-claude-auth-shim.js";
        text = ''
          export { default } from "${claude-auth-plugin}/lib/node_modules/opencode-claude-auth/dist/index.js";
        '';
      };

      direnvShim = pkgs.writeTextFile {
        name = "opencode-direnv-shim.js";
        text = ''
          export { default } from "${direnv-plugin}/lib/node_modules/@simonwjackson/opencode-direnv/dist/index.js";
        '';
      };

      opencodeConfig = pkgs.writeText "opencode.json" (
        builtins.toJSON {
          "$schema" = "https://opencode.ai/config.json";
          provider = {
            qwen-3_5-35b-a3b = {
              npm = "@ai-sdk/openai-compatible";
              name = "Qwen 3.5 35B A3B (local)";
              options.baseURL = "http://127.0.0.1:8080/v1";
              models.qwen-3_5-35b-a3b = {
                name = "Qwen 3.5 35B A3B Q5_K_M";
                limit = {
                  context = 128000;
                  output = 8192;
                };
              };
            };
          };
        }
      );

      omoConfig = pkgs.writeText "oh-my-opencode.json" (
        builtins.toJSON {
          "$schema" =
            "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/oh-my-opencode.schema.json";
          agents = {
            sisyphus = {
              model = "venice/zai-org-glm-5-1";
              variant = "max";
              fallback_models = [ "anthropic/claude-opus-4-6" ];
            };
            explore = {
              model = "venice/zai-org-glm-4.7-flash";
              fallback_models = [ "anthropic/claude-haiku-4-5" ];
            };
            oracle = {
              model = "anthropic/claude-opus-4-6";
              variant = "max";
            };
            momus = {
              model = "venice/zai-org-glm-5-1";
            };
            multimodal-looker = {
              model = "venice/kimi-k2-5";
            };
            hephaestus = {
              model = "venice/openai-gpt-54";
              variant = "medium";
            };
          };
          categories = {
            unspecified-high = {
              model = "venice/minimax-m27";
              fallback_models = [ "anthropic/claude-opus-4-6" ];
            };
            ultrabrain = {
              model = "anthropic/claude-opus-4-6";
              variant = "max";
            };
            deep = {
              model = "venice/zai-org-glm-5-1";
            };
          };
        }
      );
    in
    pkgs.writeShellApplication {
      name = "opencode";
      runtimeInputs = [
        pkgs.opencode
        pkgs.nodejs
      ];
      text = ''
        cfg="$(mktemp -d)"
        cleanup() {
          rm -rf "$cfg"
        }
        trap cleanup EXIT INT TERM

        mkdir -p "$cfg/opencode/themes" "$cfg/opencode/plugins"
        ln -s ${themeJson} "$cfg/opencode/themes/stylix.json"
        ln -s ${tuiJson} "$cfg/opencode/tui.json"
        ln -s ${pluginShim} "$cfg/opencode/plugins/oh-my-opencode.js"
        ln -s ${claudeAuthShim} "$cfg/opencode/plugins/opencode-claude-auth.js"
        ln -s ${direnvShim} "$cfg/opencode/plugins/@simonwjackson-opencode-direnv.js"
        ln -s ${omoConfig} "$cfg/opencode/oh-my-opencode.json"
        ln -s ${opencodeConfig} "$cfg/opencode/opencode.json"

        export XDG_CONFIG_HOME="$cfg"
        ${pkgs.opencode}/bin/opencode "$@"
        status=$?
        cleanup
        exit "$status"
      '';
    };

  mkWrapped =
    {
      pkgs,
      oh-my-opencode-plugin,
      claude-auth-plugin,
      direnv-plugin,
      colors ? { },
    }:
    let
      compatible = lib.versions.majorMinor pkgs.opencode.version == expectedOpencodeSeries;
    in
    assert lib.assertMsg compatible
      "oh-my-opencode ${oh-my-opencode-plugin.version} expects opencode ${expectedOpencodeSeries}.x, got ${pkgs.opencode.version}";
    (mkOpencode {
      inherit
        pkgs
        oh-my-opencode-plugin
        claude-auth-plugin
        direnv-plugin
        colors
        ;
    }).overrideAttrs
      {
        inherit (pkgs.opencode) version;
      };
in
{
  perSystem =
    { pkgs, self', ... }:
    let
      inherit (self'.packages) oh-my-opencode-plugin;
      claude-auth-plugin = self'.packages.opencode-claude-auth-plugin;
      direnv-plugin = self'.packages.opencode-direnv-plugin;
    in
    {
      packages.opencode = mkWrapped {
        inherit
          pkgs
          oh-my-opencode-plugin
          claude-auth-plugin
          direnv-plugin
          ;
      };
    };

  flake.modules.homeManager.opencode =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (self.packages.${system}) opencode;
    in
    {
      home.packages = [ opencode ];
    };

  flake.modules.nixos.opencode =
    { pkgs, config, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (self.packages.${system}) oh-my-opencode-plugin;
      claude-auth-plugin = self.packages.${system}.opencode-claude-auth-plugin;
      direnv-plugin = self.packages.${system}.opencode-direnv-plugin;
      stylixColors = lib.genAttrs baseColorNames (name: config.lib.stylix.colors.withHashtag.${name});
      wrapped = mkWrapped {
        inherit
          pkgs
          oh-my-opencode-plugin
          claude-auth-plugin
          direnv-plugin
          ;
        colors = stylixColors;
      };
    in
    {
      home-manager.sharedModules = [
        {
          programs.opencode = {
            enable = true;
            package = wrapped;
          };
        }
      ];
    };
}
