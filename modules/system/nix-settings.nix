_: {
  flake.modules.nixos.nix-settings =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;

      nix = {
        package = pkgs.lixPackageSets.latest.lix;
        settings = {
          trusted-users = [ "@wheel" ];
          extra-substituters = [
            "https://cache.nixos-cuda.org"
            "https://cache.numtide.com"
            "https://cache.lantian.pub/lantian"
          ];
          extra-trusted-public-keys = [
            "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
            "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ="
          ];
          experimental-features = [
            "nix-command"
            "flakes"
            "auto-allocate-uids"
            "cgroups"
          ];
          log-format = "multiline-with-logs";
          http-connections = 128;
          max-substitution-jobs = 128;
          system-features = [
            "benchmark"
            "big-parallel"
            "kvm"
            "nixos-test"
            "uid-range"
          ];
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
