{
  self,
  ...
}:
{
  perSystem =
    { pkgs, self', ... }:
    let
      layout = ./zellij/layouts/minimal.kdl;
      config = pkgs.replaceVars ./zellij/config.kdl {
        zsmPath = "${self'.packages.zoxide-session-manager}/bin/zsm.wasm";
        layoutPath = layout;
      };
      wrapped = pkgs.writeShellApplication {
        name = "zellij";

        runtimeInputs = [
          pkgs.zellij
        ];

        text = ''
          exec zellij \
            --config ${config} \
            --layout ${layout} \
            "$@"
        '';
      };
    in
    {
      packages.zellij = wrapped.overrideAttrs {
        inherit (pkgs.zellij) version;
      };
    };

  flake.modules.nixos.zellij =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (self.packages.${system}) zellij;
    in
    {
      home-manager.sharedModules = [
        {
          programs.zellij = {
            enable = true;
            package = zellij;
          };
        }
      ];

      environment.systemPackages = [ zellij ];
    };
}
