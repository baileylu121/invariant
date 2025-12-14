{
  self,
  lib,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.foot = pkgs.writeShellApplication {
        name = "foot";

        runtimeInputs = with pkgs; [
          foot
        ];

        text = ''
          exec foot \
            "$@"
        '';
      };
      packages.footclient = pkgs.writeShellApplication {
        name = "footclient";

        runtimeInputs = with pkgs; [
          foot
        ];

        text = ''
          exec footclient \
            "$@"
        '';
      };
    };

  flake.modules.nixos.foot =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (self.packages.${system}) foot footclient;
    in
    {
      imports = [
        self.modules.nixos.bash
      ];

      environment.systemPackages = [
        foot
        footclient
      ];

      systemd.user.services.foot = {
        enable = true;
        after = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        description = "Foot Server";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe foot} --server";
        };
        environment = lib.mkForce { };
      };
    };
}
