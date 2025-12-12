{
  description = "Invariant flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    impermanence.url = "github:nix-community/impermanence";
    disko.url = "github:nix-community/disko";
  };

  outputs = { nixpkgs, disko, impermanence, ... }: {
    nixosConfigurations.invariant = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.default
        impermanence.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
