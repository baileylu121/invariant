{
  self,
  lib,
  ...
}:
{
  flake.modules.nixos.niri =
    { pkgs, config, ... }:
    let
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
      ];

      environment.systemPackages = [
        pkgs.wl-clipboard-rs
      ];

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
