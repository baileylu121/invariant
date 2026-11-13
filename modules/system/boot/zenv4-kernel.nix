{ inputs, self, ... }:
{
  flake.modules.nixos.zenv4-kernel =
    { pkgs, ... }:
    let
      cachyPkgs = pkgs.appendOverlays [ inputs.nix-cachy-os-kernel.overlays.pinned ];
    in
    {
      imports = [
        self.modules.nixos.boot
      ];

      boot.kernelPackages = cachyPkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;
    };
}
