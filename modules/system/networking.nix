{
  flake.modules.nixos.networking = {
    services.openssh.enable = true;

    networking.hostName = "invariant";

    networking.networkmanager.enable = true;

    networking.nftables.enable = true;
    networking.firewall.checkReversePath = "loose";

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    services.tailscale.enable = true;
  };
}
