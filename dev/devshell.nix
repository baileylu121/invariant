{
  perSystem =
    { pkgs, inputs', ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          inputs'.disko.packages.default
        ];
      };
    };
}
