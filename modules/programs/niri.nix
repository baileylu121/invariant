{
  self,
  lib,
  ...
}:
{
  flake.modules.nixos.niri =
    {
      pkgs,
      config,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;

      niriConfig = pkgs.replaceVars ./niri/config.kdl {
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
      niri = pkgs.writeShellApplication {
        name = "niri";

        runtimeInputs = [
          pkgs.niri
          pkgs.wl-clipboard-rs
          self.packages.${system}.dank-material-shell
        ];

        text = ''
          exec niri \
            --config '${niriConfig}' \
            --session \
            "$@"
        '';
      };
    in
    {
      imports = [
        self.modules.nixos.foot
        self.modules.nixos.neovim
        self.modules.nixos.dank-material-shell
      ];

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
        configPackages = [ niri pkgs.niri ];
        extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      };

      programs.uwsm = {
        enable = true;
        waylandCompositors = {
          niri = {
            prettyName = "Niri";
            comment = "Niri compositor managed by UWSM";
            binPath = lib.getExe niri;
          };
        };
      };
    };
}
