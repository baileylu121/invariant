{
  description = "Doom emacs flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    doomdir = {
      url = "./.doom.d";
      flake = false;
    };

    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs = {
        doomdir.follows = "doomdir";
        nixpkgs.follows = "nixpkgs";
      };
    };

    llm-agents.url = "github:numtide/llm-agents.nix";

    pi-acp = {
      url = "git+ssh://git@github.com/baileylu121/pi-acp";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nix-doom-emacs-unstraightened,
      pi-acp,
      llm-agents,
      self,
      ...
    }:
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
            pkgs = import nixpkgs {
              inherit system;

              overlays = [ nix-doom-emacs-unstraightened.overlays.default ];

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
      packages = eachSystem (
        { callPackage, ... }:
        {
          default = callPackage ./nix/package.nix { inherit pi-acp llm-agents; };
        }
      );
      checks = eachSystem (
        { callPackage, system, ... }:
        {
          treefmt = callPackage ./nix/formatter.nix { };
          devShell = self.devShells.${system}.default;
        }
      );

      formatter = eachSystem ({ callPackage, ... }: callPackage ./nix/formatter.nix { });
    };
}
