{
  inputs,
  self,
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
      home.packages = [ emacs ];

      services.emacs = {
        enable = true;
        package = emacs;
        startWithUserSession = "graphical";
        defaultEditor = true;
        client.enable = true;
        client.arguments = [ "-c" ];
      };
    };

  flake.modules.nixos.emacs =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (self.packages.${system}) emacs;
    in
    {
      environment.variables.EDITOR = "emacsclient -nw";
      environment.systemPackages = [ emacs ];
    };
}
