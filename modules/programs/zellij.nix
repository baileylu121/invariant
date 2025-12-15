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
    in
    {
      packages.zellij = pkgs.writeShellApplication {
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
    };

  flake.modules.homeManager.zellij =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (self.packages.${system}) zellij;
    in
    {
      home.packages = [ zellij ];
    };

  flake.modules.nixos.zellij =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (self.packages.${system}) zellij;
    in
    {
      environment.systemPackages = [ zellij ];
    };
}
