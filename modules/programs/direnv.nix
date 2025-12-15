{
  self,
  ...
}:
{
  config = {
    perSystem =
      { pkgs, ... }:
      {
        packages.direnv = pkgs.writeShellApplication {
          name = "direnv";

          runtimeInputs = [
            pkgs.direnv
          ];

          runtimeEnv = {
            DIRENV_CONFIG = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
          };

          text = ''
            exec direnv "$@"
          '';
        };
      };

    flake.modules.homeManager.direnv =
      { pkgs, ... }:
      let
        inherit (pkgs.stdenv.hostPlatform) system;
        inherit (self.packages.${system}) direnv;
      in
      {
        home.packages = [ direnv ];
      };

    flake.modules.nixos.direnv =
      { pkgs, ... }:
      let
        inherit (pkgs.stdenv.hostPlatform) system;
        inherit (self.packages.${system}) direnv;
      in
      {
        environment.systemPackages = [ direnv ];
      };
  };
}
