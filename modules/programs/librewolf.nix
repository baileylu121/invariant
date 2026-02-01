{ inputs, lib, ... }:
{
  flake.modules.nixos.librewolf =
    { pkgs, ... }:
    {
      home-manager.backupFileExtension = "hm-backup";

      home-manager.sharedModules = [
        (
          { config, ... }:
          let
            inherit (config.lib.stylix.colors.withHashtag)
              base01
              base07
              ;
          in
          {
            programs.librewolf = {
              enable = true;

              profiles."0" = {
                id = 0;
                isDefault = true;
                name = "0";

                extensions.packages =
                  with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
                  [
                    ublock-origin
                    vimium-c
                  ]
                  ++ lib.optional (config.stylix.polarity == "dark") darkreader;

                search.default = "ddg";
                search.force = true;

                settings = {
                  "webgl.disabled" = true;
                  "permissions.default.shortcuts" = 2;
                };
              };
            };

            stylix.targets.librewolf.profileNames = [ "0" ];
          }
        )
      ];
    };
}
