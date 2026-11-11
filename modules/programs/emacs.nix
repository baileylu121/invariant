{
  inputs,
  self,
  lib,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    let
      doomOverlay = inputs.nix-doom-emacs-unstraightened.overlays.default;
      pkgsWithDoom = pkgs.extend doomOverlay;
    in
    {
      packages.emacs = pkgsWithDoom.callPackage ./emacs/_package.nix {
        inherit (inputs) llm-agents pi-acp;
      };
    };

  flake.modules.homeManager.emacs =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (self.packages.${system}) emacs;
    in
    {
      home.sessionVariables.EDITOR = lib.getExe emacs;
      home.packages = [ emacs ];
    };

  flake.modules.nixos.emacs =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (self.packages.${system}) emacs;
    in
    {
      environment.variables.EDITOR = lib.getExe emacs;
      environment.systemPackages = [ emacs ];
    };
}
