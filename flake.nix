{
  description = "Flake with only nixpkgs dependencies";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, self, ... }:
    let
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      eachSystem =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
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
