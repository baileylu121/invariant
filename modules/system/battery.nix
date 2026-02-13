{
  flake.modules.nixos.battery = {
    services.tlp.enable = true;
    services.tlp.pd.enable = true;
  };
}
