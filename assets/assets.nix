{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.assets = mkOption {
    description = ''
      Assets paths map
    '';
    type = types.lazyAttrsOf types.path;
  };

  config.assets = {
    sunsetMountains = ./sunset-mountains.jpg;
  };
}
