{ inputs, self, ... }:
let
  zenv4Overlay = _: _: {
    localSystem = {
      gcc.arch = "znver4";
      gcc.tune = "znver4";
      system = "x86_64-linux";
    };
  };
in
{
  flake.modules.nixos.zenv4-kernel =
    { pkgs, ... }:
    let
      zen4Pkgs = pkgs.appendOverlays [
        inputs.nix-cachy-os-kernel.overlays.default
        zenv4Overlay
      ];
    in
    {
      imports = [
        self.modules.nixos.boot
      ];

      boot.kernelPackages = zen4Pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
    };
}
