{ inputs, ... }:
{
  imports = [ inputs.nimi.flakeModules.default ];

  perSystem =
    { system, ... }:
    let
      llama-swap-lib = inputs.llama-swap-nix.lib.${system};

      qwen-3-6-35b-a3b = llama-swap-lib.fetchHuggingFace {
        url = "https://huggingface.com/byteshape/Qwen3.6-35B-A3B-GGUF/resolve/main/Qwen3.6-35B-A3B-Q4_K_S-4.22bpw.gguf";
        hash = "sha256-nu54tkiirNCBDYImVNwe2YeN2M0lfn2yu7BZ3hl7EJg=";
        name = "Qwen 3.6 35B A3B";
      };
    in
    {
      nimi."llama-swap".services."llama-swap" = {
        imports = [ llama-swap-lib.module ];

        llama-swap.listen = "localhost:16320";
        llama-swap.config = llama-swap-lib.writeLLamaSwapCfgFile {
          models."Qwen 3.6 35B A3B" = {
            cmd = llama-swap-lib.formatLlamaCmd {
              package = inputs.ik-llama-cpp.packages.${system}.cuda.overrideDerivation (oldAttrs: {
                cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
                  "-DCMAKE_C_FLAGS=-march=znver5"
                  "-DCMAKE_CXX_FLAGS=-march=znver5"
                ];
              });

              args = {
                model = qwen-3-6-35b-a3b;
                ctx-size = 262144;
                temp = 0.6;
                top-p = 0.95;
                top-k = 20;
                min-p = 0.0;
                presence-penalty = 0.0;
                repeat-penalty = 1.0;
                jinja = true;
                peg = true;
                batch-size = 8192;
                ubatch-size = 2048;
                chat-template-kwargs = "'{\"preserve_thinking\": true}'";

                parallel = 1;
                gpu-layers = 99;
                fit = true;
                fit-margin = 1024;
                flash-attn = "on";
                threads-batch = 24;
                threads = 12;
                merge-qkv = true;
                merge-up-gate-experts = true;

                k-cache-hadamard = true;
                v-cache-hadamard = true;
                cache-type-k = "q4_0";
                cache-type-v = "q4_0";

                port = 16321;
              };

              env = {
                __NV_PRIME_RENDER_OFFLOAD = 1;
                __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
                __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                GGML_CUDA_GRAPH_OPT = 1;
              };
            };

            proxy = "http://localhost:16321";
          };
        };
      };
    };
}
