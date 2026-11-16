{
  flake.modules.nixos.battery = {
    services.upower = {
      enable = true;
      criticalPowerAction = "PowerOff";
    };
    services.tlp.enable = true;
    services.tlp.pd.enable = true;
  };
}
