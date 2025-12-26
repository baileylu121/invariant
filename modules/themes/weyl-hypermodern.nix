{ inputs, ... }:
let
  inherit (inputs) stylix;
in
{
  flake.modules.nixos.theme-hypermodern =
    { pkgs, ... }:
    {
      imports = [
        stylix.nixosModules.stylix
      ];

      stylix = {
        enable = true;
        base16Scheme = {
          base00 = "090b0e";
          base01 = "13161a";
          base02 = "1a1f24";
          base03 = "23292f";
          base04 = "596775";
          base05 = "d8e0e7";
          base06 = "e0f4ff";
          base07 = "e6f7ff";
          base08 = "218bff";
          base09 = "54aeff";
          base0A = "80ccff";
          base0B = "6dd9ff";
          base0C = "40e0d0";
          base0D = "1166b0";
          base0E = "b0e1ff";
          base0F = "8ecbff";
        };

        image = pkgs.copyPathToStore ./weyl-hypermodern/background.jpg;

        targets.qt.enable = true;

        polarity = "dark";
        opacity.terminal = 0.8;

        fonts = {
          serif = {
            package = pkgs.google-fonts;
            name = "Aldrich";
          };

          sansSerif = {
            package = pkgs.google-fonts;
            name = "Aldrich";
          };

          monospace = {
            package = pkgs.nerd-fonts.iosevka;
            name = "Iosevka Nerd Font Mono";
          };

          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };
      };
    };
}
