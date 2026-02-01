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
          base02 = "1f2228";
          base03 = "3d424a";
          base04 = "515761";
          base05 = "676d77";
          base06 = "8b919a";
          base07 = "e0dcd4";
          base08 = "c8beb8";
          base09 = "ccc4b4";
          base0A = "d4ccb4";
          base0B = "b8c4b8";
          base0C = "b4c0c8";
          base0D = "b4bcc4";
          base0E = "b4c4bc";
          base0F = "98a4ac";
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
