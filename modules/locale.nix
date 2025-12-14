{
  flake.modules.nixos.locale = {
    services.xserver.xkb.layout = "gb";
    console.useXkbConfig = true;

    i18n.defaultLocale = "en_GB.UTF-8";

    time.timeZone = "Europe/Dublin";

    services.libinput.enable = true;
  };
}
