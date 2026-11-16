{
  inputs,
  ...
}:
{
  config = {
    flake.modules.nixos.direnv = {
      imports = [
        inputs.iets.nixosModules.default
      ];

      programs.direnv = {
        enable = true;
        enableBashIntegration = false;
      };

      iets.direnv.enable = true;
    };

    flake.modules.homeManager.direnv = {
      programs.direnv.enable = true;
    };
  };
}
