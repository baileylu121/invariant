{ inputs, ... }:
{
  imports = [ inputs.nimi.flakeModules.default ];

  perSystem =
    { system, pkgs, ... }:
    let
      llama-swap-lib = inputs.llama-swap-nix.lib.${system};
      args = {
        inherit
          inputs
          system
          pkgs
          llama-swap-lib
          ;
      };
    in
    {
      nimi."llama-swap".services."llama-swap" = {
        imports = [ llama-swap-lib.module ];

        llama-swap.listen = "localhost:16320";
        llama-swap.config = llama-swap-lib.writeLLamaSwapCfgFile {
          imports = [
            (import ./_llama-swap/qwen-3-6.nix args)
            (import ./_llama-swap/qwen-3-8-flash-next.nix args)
          ];

          healthCheckTimeout = 600;
        };
      };
    };
}
