{
  flake.modules.nixos.usersLuke =
    { pkgs, ... }:
    {
      users.users.luke = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        packages = with pkgs; [
          tree
        ];
        initialPassword = "4835";
      };

      programs.niri.enable = true;

      environment.systemPackages = with pkgs; [
        ghostty
        librewolf
        neovim
        git
      ];
    };
}
