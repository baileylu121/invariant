{
  self,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  flake.modules.nixos.niri =
    {
      pkgs,
      config,
      ...
    }:
    let
      zen4Pkgs = pkgs.appendOverlays [
        self.overlays.zen4
      ];
    in
    {

      options.niriConfig = mkOption {
        type = types.pathInStore;
        description = ''
          Niri config.kdl to use system wide
        '';
        default = pkgs.replaceVars ./niri/config.kdl {
          inherit (config.lib.stylix.colors.withHashtag)
            base00
            base03
            base08
            base0A
            base0D
            ;

          DEFAULT_AUDIO_SINK = "null";
          DEFAULT_AUDIO_SOURCE = "null";
        };
      };

      imports = [
        self.modules.nixos.foot
        self.modules.nixos.neovim
        self.modules.nixos.dank-material-shell
      ];

      config = {
        environment.systemPackages = [
          pkgs.wl-clipboard-rs
          pkgs.xdg-desktop-portal-gnome
        ];

        home-manager.sharedModules = [
          {
            home.packages = [
              pkgs.xdg-desktop-portal-gnome
            ];
          }
        ];

        xdg.portal = {
          enable = true;
          configPackages = [
            zen4Pkgs.niri
          ];
          extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
        };

        programs.niri = {
          enable = true;
          package = zen4Pkgs.niri;
        };

        environment.etc."niri/config.kdl".source = config.niriConfig;
      };
    };
}
