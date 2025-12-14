{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          cudaSupport = true;
          allowUnfree = true;
          rocmSupport = false;
        };
      };
    };
}
