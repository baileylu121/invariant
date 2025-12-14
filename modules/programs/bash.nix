{
  self,
  ...
}:
{
  config = {
    perSystem =
      { pkgs, ... }:
      let
        bashrc = pkgs.replaceVars ./bash/.bashrc {
          bleshPath = "${pkgs.blesh}/share/blesh/ble.sh";
        };
      in
      {
        packages.bash = pkgs.writeShellApplication {
          name = "bash";

          runtimeInputs = with pkgs; [
            bash
            blesh

            atuin
            zoxide

            bat
            eza

            direnv
          ];

          text = ''
            exec bash "$@" \
              --rcfile ${bashrc}
          '';
        };
      };

    flake.modules.homeManager.bash =
      { pkgs, ... }:
      let
        inherit (pkgs.stdenv.hostPlatform) system;
      in
      {
        home.packages = [
          self.packages.${system}.bash
        ];
      };

    flake.modules.nixos.bash =
      { pkgs, ... }:
      let
        inherit (pkgs.stdenv.hostPlatform) system;
        inherit (self.packages.${system}) bash;
      in
      {
        users.defaultUserShell = bash;
        environment.systemPackages = [ bash ];
      };
  };
}
