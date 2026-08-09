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
            "auto-allocate-uids"
            "cgroups"
          ];
          log-format = "multiline-with-logs";
          http-connections = 128;
          max-substitution-jobs = 128;
          system-features = [ "benchmark" "big-parallel" "kvm" "nixos-test" "uid-range" ];
          auto-allocate-uids = true;
          use-cgroups = true;
        };
      };

      system.stateVersion = "25.11";
    };

  flake.modules.homeManager.nix-settings = {
    nixpkgs.config.allowUnfree = true;
  };
}
