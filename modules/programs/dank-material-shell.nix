{
  inputs,
  ...
}:
let
  mkDmsConfig =
    { dms-shell, pkgs }:
    let
      cacheJson = pkgs.replaceVars ./dank-material-shell/cache.json {
        wallpaperPath = ./dank-material-shell/sunset-mountains.jpg;
      };
      sessionJson = pkgs.replaceVars ./dank-material-shell/session.json {
        wallpaperPath = ./dank-material-shell/sunset-mountains.jpg;
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

        ln -sf ${./dank-material-shell/settings.json} "$XDG_CONFIG_HOME/DankMaterialShell/settings.json"
        ln -sf ${cacheJson} "$XDG_CACHE_HOME/DankMaterialShell/cache.json"
        ln -sf ${sessionJson} "$XDG_STATE_HOME/DankMaterialShell/session.json"

        exec dms run "$@"
      '';
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
        wallpaper = config.lib.stylix.image;
      };
    in
    {
      environment.systemPackages = [ dms ];
    };
}
