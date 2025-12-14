{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt = {
    projectRootFile = "flake.nix";

    programs = {
      statix.enable = true;
      deadnix.enable = true;
      mdformat.enable = true;
      nixfmt.enable = true;

      stylua.enable = true;
    };
  };
}
