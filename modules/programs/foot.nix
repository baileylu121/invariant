{
  self,
  lib,
  ...
}:
{
  flake.modules.nixos.foot =
    { pkgs, ... }:
    {
      imports = [
        self.modules.nixos.bash
      ];

      home-manager.sharedModules = [
        {
          programs.foot.enable = true;
        }
      ];

      systemd.user.services.foot = {
        enable = true;
        after = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        description = "Foot Server";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.foot} --server";
        };
        environment = lib.mkForce { };
      };
    };
}
