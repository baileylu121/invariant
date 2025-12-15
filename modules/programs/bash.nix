{
  self,
  lib,
  ...
}:
let
  runtimeInputs =
    pkgs:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    with pkgs;
    [
      blesh
      self.packages.${system}.zellij

      atuin
      zoxide

      bat
      eza

      self.packages.${system}.direnv
      nh

      starship
    ];
in
{
  config = {
    perSystem =
      { pkgs, ... }:
      let
        bashrc = pkgs.replaceVars ./bash/.bashrc {
          bleshPath = "${pkgs.blesh}/share/blesh/ble.sh";
        };
      in
      rec {
        packages.bash = pkgs.writeShellApplication {
          name = "bash";

          runtimeInputs = [
            pkgs.bash
          ]
          ++ runtimeInputs pkgs;

          text = ''
            exec bash \
              --rcfile ${bashrc} \
              "$@"
          '';

          passthru.shellPath = "/bin/bash";
        };
      };

    flake.modules.homeManager.bash =
      { pkgs, ... }:
      let
        inherit (pkgs.stdenv.hostPlatform) system;
        inherit (self.packages.${system}) bash;
      in
      {
        home.sessionVariables.SHELL = lib.getExe bash;
        home.packages = [ bash ] ++ runtimeInputs pkgs;
      };

    flake.modules.nixos.bash =
      { pkgs, ... }:
      let
        inherit (pkgs.stdenv.hostPlatform) system;
        inherit (self.packages.${system}) bash;
      in
      {
        environment.variables.SHELL = lib.getExe bash;
        users.defaultUserShell = bash;
        environment.systemPackages = [ bash ] ++ runtimeInputs pkgs;
      };
  };
}
