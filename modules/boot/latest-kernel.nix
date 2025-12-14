{ self, ... }:
{
  flake.modules.nixos.latest-kernel =
    { pkgs, ... }:
    {
      imports = [
        self.modules.nixos.boot
      ];

      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}
