{
  self,
  ...
}:
{
  perSystem =
    { pkgs, inputs', ... }:
    {
      packages.quickshell = pkgs.writeShellApplication {
        name = "quickshell";

        runtimeEnv = {
          QT_QPA_PLATFORMTHEME = "gtk3";
        };

        runtimeInputs = [
          inputs'.qml-niri.packages.quickshell
        ];

        text = ''
          exec quickshell \
            --config ${./quickshell} \
            "$@"
        '';
      };
    };

  flake.modules.nixos.quickshell =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (self.packages.${system}) quickshell;
    in
    {
      environment.systemPackages = [ quickshell ];
    };
}
