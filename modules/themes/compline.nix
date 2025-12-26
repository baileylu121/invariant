{ inputs, ... }:
let
  inherit (inputs) stylix;
in
{
  flake.modules.nixos.theme-compline =
    { pkgs, ... }:
    {
      imports = [
        stylix.nixosModules.stylix
      ];

      stylix = {
        enable = true;
        base16Scheme = {
          base00 = "1a1d21";
          base01 = "22262b";
          base02 = "282c34";
          base03 = "3d424a";
          base04 = "c0bdb8";
          base05 = "e0dcd4";
          base06 = "e8e4dc";
          base07 = "f5f2eb";
          base08 = "c8beb8";
          base09 = "c8c0b0";
          base0A = "ccc4b0";
          base0B = "b4beb4";
          base0C = "b0bcc8";
          base0D = "b4bec8";
          base0E = "c4beb8";
          base0F = "c0b8bc";
        };

        image = pkgs.copyPathToStore ./compline/sunset-mountains.jpg;

        targets.qt.enable = true;

        polarity = "dark";
        opacity.terminal = 0.8;

        fonts = {
          serif = {
            package = pkgs.geist-font;
            name = "Geist";
          };

          sansSerif = {
            package = pkgs.geist-font;
            name = "Geist Sans";
          };

          monospace = {
            package = pkgs.nerd-fonts.geist-mono;
            name = "Geist Mono";
          };

          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };
      };
    };
}
