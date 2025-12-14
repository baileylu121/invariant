{
  flake.modules.nixos.battery = {
    services.tlp.enable = true;
  };
}
