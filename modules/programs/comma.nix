{
  inputs,
  ...
}:
let
  inherit (inputs) nix-index-database;
in
{
  flake.modules.homeManager.comma = {
    imports = [
      nix-index-database.homeModules.default
    ];

    programs.nix-index-database.comma.enable = true;
  };
}
