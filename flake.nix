{
  description = "Doom emacs flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs = {
        doomdir.url = "./.doom.d";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    { nixpkgs, self, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      eachSystem =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          f {
            inherit (pkgs) callPackage;
            inherit pkgs system;
          }
        );
    in
    {
      devShells = eachSystem (
        { callPackage, ... }:
        {
          default = callPackage ./nix/devshell.nix { };
        }
      );
      checks = eachSystem (
        { callPackage, system, ... }:
        {
          treefmt = callPackage ./nix/devshell.nix { };
          devShell = self.devShells.${system}.default;
        }
      );

      formatter = eachSystem ({ callPackage, ... }: callPackage ./nix/formatter.nix { });
    };
}
