{ inputs, self, ... }:
{
  flake.modules.nixos.zenv4-kernel =
    { pkgs, ... }:
    let
      zen4Pkgs = pkgs.appendOverlays [
        inputs.nix-cachy-os-kernel.overlays.default
        self.overlays.zen4
      ];
    in
    {
      imports = [
        self.modules.nixos.boot
      ];

      boot.kernelPackages = zen4Pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
    };
}
