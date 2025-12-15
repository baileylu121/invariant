{
  flake.modules.nixos.display-manager = {
    services.displayManager.ly.enable = true;

    systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";
  };
}
