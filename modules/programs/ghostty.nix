{
  self,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.ghostty =
        pkgs.runCommandLocal "wrap-ghostty"
          {
            nativeBuildInputs = [
              pkgs.makeWrapper
            ];
          }
          ''
            cp -R "${pkgs.ghostty}/." "$out"

            chmod -R u+rwx "$out/bin"

            wrapProgram "$out/bin/ghostty" \
              --add-flags "--config-file=${./ghostty/config}"
          '';
    };

  flake.modules.homeManager.ghostty =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (self.packages.${system}) ghostty;
    in
    {
      imports = [
        self.modules.homeManager.bash
      ];

      programs.ghostty = {
        enable = true;
        package = ghostty;
      };
    };
}
