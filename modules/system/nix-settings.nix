{ inputs, ... }:
{
  flake.modules.nixos.nix-settings = {
    imports = [
      inputs.determinate.nixosModules.default
    ];

    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      trusted-users = [ "@wheel" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    system.stateVersion = "25.11";
  };

  flake.modules.homeManager.nix-settings = {
    nixpkgs.config.allowUnfree = true;
  };
}
