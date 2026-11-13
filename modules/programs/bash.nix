{
  inputs,
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
      ripgrep
      fzf
      fff
      ast-grep
      fd
      jq
      gnumake
      lefthook

      git
      lazygit
      gh
      glab
      graphite-cli

      pi-coding-agent
      claude-code
      inputs.llm-agents.packages.${system}.omp
      inputs.llm-agents.packages.${system}.codex
      (herdr-desktop.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ zstd ];
      }))
      herdr-core

      btop

      self.packages.${system}.direnv
      nh

      starship
    ];

  mkBashrc =
    pkgs:
    pkgs.replaceVars ./bash/.bashrc {
      bleshPath = "${pkgs.blesh}/share/blesh/ble.sh";
    };
in
{
  config = {
    perSystem =
      { pkgs, ... }:
      let
        bashrc = mkBashrc pkgs;
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
        home.file.".bashrc".source = mkBashrc pkgs;
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
