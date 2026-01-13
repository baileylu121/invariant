{
  flake.modules.nixos.nvidia =
    { config, ... }:
    {
      hardware.graphics.enable = true;

      services.xserver.videoDrivers = [
        "amdgpu"
        "nvidia"
      ];

      hardware.nvidia = {
        modesetting.enable = true;

        powerManagement.enable = true;
        powerManagement.finegrained = true;

        open = true;

        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.latest;

        prime = {
          offload.enable = true;
          amdgpuBusId = "PCI:101:0:0";
          nvidiaBusId = "PCI:100:0:0";
        };
      };

      hardware.nvidia-container-toolkit.enable = true;
    };
}
