{ inputs, self, ... }:
let
  inherit (inputs) home-manager nixpkgs;
in
{
  imports = [
    home-manager.flakeModules.home-manager
  ];

  flake.modules.homeManager.luke = {
    imports = [
      self.modules.homeManager.neovim
      self.modules.homeManager.bash
    ];

    programs.git = {
      enable = true;
      settings.user = {
        email = "baileylu@tcd.ie";
        name = "Luke Bailey";
      };
    };

    home = {
      username = "luke";
      stateVersion = "25.11";
      homeDirectory = "/home/luke";
    };
  };

  flake.modules.nixos.users-luke =
    { pkgs, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.default
        self.modules.nixos.bash
      ];

      users.users.luke = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        initialPassword = "4835";
      };

      home-manager.users.luke = self.modules.homeManager.luke;

      programs.niri.enable = true;

      environment.systemPackages = with pkgs; [
        ghostty
        librewolf
      ];
    };

  flake.homeConfigurations.luke = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    modules = [ self.modules.homeManager.luke ];
  };
}
