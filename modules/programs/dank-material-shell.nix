{
  inputs,
  ...
}:
let

  mkDmsConfig =
    {
      dms-shell,
      pkgs,
      wallpaper ? ./dank-material-shell/sunset-mountains.jpg,
      font ? "Montserrat",
      fontMono ? "GeistMono Nerd Font",

      base00 ? "#1a1d21",
      base01 ? "#22262b",
      base02 ? "#1f2228",
      base03 ? "#3d424a",
      base06 ? "#8b919a",
      base07 ? "#e0dcd4",
      base08 ? "#c8beb8",
      base0A ? "#d4ccb4",
      base0C ? "#b4c0c8",
      base0D ? "#b4bcc4",
      base0E ? "#b4c4bc",
    }:
    let
      theme = builtins.toFile "theme.json" (
        builtins.toJSON {
          name = "stylix";

          primary = base0D;
          primaryText = base00;
          primaryContainer = base0C;

          secondary = base0E;
          surfaceTint = base0D;

          surface = base01;
          surfaceText = base06;
          surfaceVariant = base02;
          surfaceVariantText = base07;

          background = base00;
          backgroundText = base06;

          outline = base03;

          error = base08;
          warning = base0A;
          info = base0C;

          matugen_type = "scheme-tonal-spot";
        }
      );

      settingsJson = pkgs.replaceVars ./dank-material-shell/settings.json {
        inherit font fontMono theme;
      };
      cacheJson = pkgs.replaceVars ./dank-material-shell/cache.json {
        wallpaperPath = wallpaper;
      };
      sessionJson = pkgs.replaceVars ./dank-material-shell/session.json {
        wallpaperPath = wallpaper;
      };
    in

    pkgs.writeShellApplication {
      name = "dank-material-shell";

      runtimeInputs = [
        pkgs.quickshell
        dms-shell
      ];

      runtimeEnv = {
        DMS_DISABLE_MATUGEN = 1;
      };

      text = ''
        XDG_CONFIG_HOME="$(mktemp -d)"
        XDG_CACHE_HOME="$(mktemp -d)"
        XDG_STATE_HOME="$(mktemp -d)"

        mkdir -p "$XDG_CONFIG_HOME/DankMaterialShell"
        mkdir -p "$XDG_CACHE_HOME/DankMaterialShell"
        mkdir -p "$XDG_STATE_HOME/DankMaterialShell"

        ln -sf ${settingsJson} "$XDG_CONFIG_HOME/DankMaterialShell/settings.json"
        ln -sf ${cacheJson} "$XDG_CACHE_HOME/DankMaterialShell/cache.json"
        ln -sf ${sessionJson} "$XDG_STATE_HOME/DankMaterialShell/session.json"
        ln -sf ${theme} "$XDG_CONFIG_HOME/DankMaterialShell/theme.json"

        exec dms run "$@"
      '';

      passthru = {
        inherit
          settingsJson
          cacheJson
          sessionJson
          theme
          ;
      };
    };
in
{
  perSystem =
    { pkgs, inputs', ... }:
    {
      packages.dank-material-shell = mkDmsConfig {
        inherit (inputs'.dank-material-shell.packages) dms-shell;
        inherit pkgs;
      };
    };

  flake.modules.nixos.dank-material-shell =
    { pkgs, config, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;

      dms = mkDmsConfig {
        inherit (inputs.dank-material-shell.packages.${system}) dms-shell;
        inherit pkgs;
        wallpaper = config.stylix.image;
        font = config.stylix.fonts.serif.name;
        fontMono = config.stylix.fonts.monospace.name;

        inherit (config.lib.stylix.colors.withHashtag)
          base00
          base01
          base02
          base03
          base06
          base07
          base08
          base0A
          base0C
          base0D
          base0E
          ;
      };
    in
    {
      environment.systemPackages = [ dms ];

      home-manager.sharedModules = [
        {
          home.file = {
            ".config/DankMaterialShell/settings.json".source = dms.settingsJson;
            ".cache/DankMaterialShell/cache.json".source = dms.cacheJson;
            ".local/state/DankMaterialShell/session.json".source = dms.sessionJson;
          };
        }
      ];

      services.displayManager.dms-greeter =
        let
          cfgFiles = pkgs.linkFarm "dms-cfg" [
            {
              name = "settings.json";
              path = dms.settingsJson;
            }
            {
              name = "session.json";
              path = dms.sessionJson;
            }
            {
              name = "cache.json";
              path = dms.cacheJson;
            }
          ];
        in
        {
          enable = true;
          logs.save = true;
          compositor.name = "niri";
          compositor.customConfig = builtins.readFile config.niriConfig;
          configFiles = [
            "${cfgFiles}/settings.json"
            "${cfgFiles}/session.json"
            "${cfgFiles}/cache.json"
          ];
        };
    };
}
