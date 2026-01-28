{
  writeShellApplication,
  treefmt,
  lib,
  writers,
  deadnix,
  mdformat,
  nixfmt,
  statix,
}:
let
  statix-fix = writeShellApplication {
    name = "statix-fix";
    text = ''
      for file in "$@"; do
        ${lib.getExe statix} fix "$file"
      done
    '';
  };

  treefmtToml = writers.writeTOML "treefmt.toml" {
    formatter = {
      mdformat = {
        command = lib.getExe mdformat;
        excludes = [ ];
        includes = [ "*.md" ];
        options = [ ];
      };

      deadnix = {
        command = lib.getExe deadnix;
        excludes = [ ];
        includes = [ "*.nix" ];
        options = [ "--edit" ];
      };

      nixfmt = {
        command = lib.getExe nixfmt;
        excludes = [ ];
        includes = [ "*.nix" ];
        options = [ ];
      };

      statix = {
        command = lib.getExe statix-fix;
        excludes = [ ];
        includes = [ "*.nix" ];
        options = [ ];
      };
    };
  };
in
treefmt.withConfig {
  name = "formatter";
  configFile = treefmtToml;
}
