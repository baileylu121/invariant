{
  flake.modules.nixos.networking = {
    services.openssh.enable = true;

    networking.hostName = "invariant";

    networking.networkmanager.enable = true;

    networking.nftables.enable = true;
  };
}
