{ inputs, self, ... }:
{
  flake.modules.nixos.users-luke =
    { pkgs, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.default
      ];

      users.users.luke = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        initialPassword = "4835";
      };

      home-manager.users.luke = {
        imports = [
          self.modules.homeManager.neovim
        ];

        programs.git = {
          enable = true;
          userEmail = "baileylu@tcd.ie";
          userName = "Luke Bailey";
        };

        home.stateVersion = "25.11";
      };

      programs.niri.enable = true;

      environment.systemPackages = with pkgs; [
        ghostty
        librewolf
      ];
    };
}
