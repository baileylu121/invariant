{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./impermenance.nix
      ./disko.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "invariant"; # Define your hostname.

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Dublin";

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    useXkbConfig = true; # use xkb.options in tty.
  };

  programs = {
	niri.enable = true;
  };

  environment.systemPackages = with pkgs; [
	ghostty
	librewolf
	neovim
	git
  ];

  nix = {
	settings.experimental-features = [ "nix-command" "flakes" ];
  };

  services.xserver.xkb.layout = "gb";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  users.users.luke = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    initialPassword = "4835";
  };

  services.openssh.enable = true;

  system.stateVersion = "25.11";
}

