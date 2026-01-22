{ self, inputs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  flake.nixosConfigurations.proart-p16-h7606wp = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.btrfs-filesystem
      self.modules.nixos.btrfs-impermanence

      self.modules.nixos.audio
      self.modules.nixos.networking

      self.modules.nixos.battery

      self.modules.nixos.locale
      self.modules.nixos.nix-settings

      self.modules.nixos.nvidia
      self.modules.nixos.zenv4-kernel

      self.modules.nixos.users-luke

      (
        {
          config,
          lib,
          modulesPath,
          ...
        }:
        {
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
          ];

          boot.initrd.availableKernelModules = [
            "nvme"
            "xhci_pci"
            "thunderbolt"
            "usbhid"
            "usb_storage"
            "sd_mod"
            "sdhci_pci"
          ];
          boot.initrd.kernelModules = [ ];
          boot.kernelModules = [ "kvm-amd" ];
          boot.extraModulePackages = [ ];

          swapDevices = [ ];

          nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
          hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        }
      )
    ];
  };
}
