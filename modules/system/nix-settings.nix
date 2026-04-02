_: {
  flake.modules.nixos.nix-settings =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;

      nix = {
        package = pkgs.lixPackageSets.latest.lix;
        settings = {
          trusted-users = [ "@wheel" ];
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          log-format = "multiline-with-logs";
          http-connections = 128;
          max-substitution-jobs = 128;
          sandbox = "relaxed";
        };
      };

      system.stateVersion = "25.11";
    };

  flake.modules.homeManager.nix-settings = {
    nixpkgs.config.allowUnfree = true;
  };
}
