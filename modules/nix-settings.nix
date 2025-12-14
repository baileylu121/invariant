{ inputs, ... }:
{
  flake.modules.nixos.nix-settings = {
    imports = [
      inputs.determinate.nixosModules.default
    ];

    nix.settings = {
      trusted-users = [ "@wheel" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    system.stateVersion = "25.11";

  };
}
