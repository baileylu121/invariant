{
  self,
  lib,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.niri = pkgs.writeShellApplication {
        name = "niri";

        runtimeInputs = with pkgs; [
          niri
        ];

        text = ''
          exec niri \
            --config '${./niri/config.kdl}' \
            --session \
            "$@"
        '';
      };
    };

  flake.modules.nixos.niri =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (self.packages.${system}) niri;
    in
    {
      imports = [
        self.modules.nixos.foot
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
