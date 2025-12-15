{
  self,
  ...
}:
{
  config = {
    perSystem =
      { pkgs, ... }:
      {
        packages.zellij = pkgs.writeShellApplication {
          name = "zellij";

          runtimeInputs = [
            pkgs.zellij
          ];

          text = ''
            exec zellij \
              --config ${./zellij/config.kdl} \
              --layout ${./zellij/layout.kdl} \
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
  };
}
