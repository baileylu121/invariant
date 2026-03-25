{ inputs, lib, ... }:
let
  qwen-3_5-35b-a3b =
    pkgs:
    pkgs.fetchurl {
      url = "https://huggingface.co/bartowski/Qwen_Qwen3.5-35B-A3B-GGUF/resolve/main/Qwen_Qwen3.5-35B-A3B-Q5_K_M.gguf";
      hash = "sha256-8JLxFeLGGUGjni6cbmIqfq3hmGmmY9Q1vuk1/o3VtVk=";
    };

  mkLlamaServer =
    {
      pkgs,
      system,
    }:
    let
      model = qwen-3_5-35b-a3b pkgs;
      llama-cpp = inputs.ik-llama-cpp.packages.${system}.cuda.overrideDerivation (oldAttrs: {
        cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
          "-DCMAKE_C_FLAGS=-march=znver5"
          "-DCMAKE_CXX_FLAGS=-march=znver5"
        ];
      });
    in
    pkgs.writeShellApplication {
      name = "llama-server-qwen";
      runtimeInputs = [ llama-cpp ];
      runtimeEnv = {
        __NV_PRIME_RENDER_OFFLOAD = 1;
        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        GGML_CUDA_GRAPH_OPT = 1;
      };
      text = ''
        exec llama-server \
          --model ${model} \
          -c 131072 \
          --parallel 1 \
          -ngl 99 \
          --n-cpu-moe 35 \
          -fa on \
          --cache-type-k q8_0 \
          --cache-type-v q8_0 \
          --threads-batch 24 \
          -t 12 \
          --temp 0.6 \
          --top-p 0.95 \
          --top-k 20 \
          --min-p 0.0 \
          --presence-penalty 0.0 \
          --repeat-penalty 1.0 \
          --jinja \
          -b 4096 \
          "$@"
      '';
    };
in
{
  perSystem =
    { pkgs, system, ... }:
    {
      packages.llama-server = mkLlamaServer { inherit pkgs system; };
    };

  flake.modules.nixos.llama-server =
    { config, pkgs, ... }:
    let
      cfg = config.services.llama-server;
      inherit (pkgs.stdenv.hostPlatform) system;
      llamaServer = mkLlamaServer { inherit pkgs system; };
    in
    {
      options.services.llama-server = {
        enable = lib.mkEnableOption "ik_llama.cpp llama-server with Qwen 3.5 35B A3B";

        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Address to bind the server to.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 8080;
          description = "Port to bind the server to.";
        };

        contextSize = lib.mkOption {
          type = lib.types.int;
          default = 131072;
          description = "Context window size in tokens.";
        };

        gpuLayers = lib.mkOption {
          type = lib.types.int;
          default = 99;
          description = "Number of model layers to offload to GPU. 99 offloads all possible layers.";
        };

        cpuMoeLayers = lib.mkOption {
          type = lib.types.int;
          default = 35;
          description = "Number of MoE expert layers to keep on CPU. Lower = faster but more VRAM. Tune down from 35 until VRAM fills to ~7.5 GB.";
        };

        extraArgs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Extra arguments passed verbatim to llama-server.";
          example = [
            "--threads"
            "8"
            "--parallel"
            "4"
          ];
        };
      };

      config = lib.mkIf cfg.enable {
        users.users.llama-server = {
          isSystemUser = true;
          group = "llama-server";
          description = "ik_llama.cpp llama-server service user";
        };

        users.groups.llama-server = { };

        systemd.services.llama-server = {
          description = "ik_llama.cpp llama-server (Qwen 3.5 35B A3B)";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          serviceConfig = {
            ExecStart = lib.escapeShellArgs (
              [
                "${llamaServer}/bin/llama-server-qwen"
                "--host"
                cfg.host
                "--port"
                (toString cfg.port)
                "--ctx-size"
                (toString cfg.contextSize)
                "--n-gpu-layers"
                (toString cfg.gpuLayers)
                "--n-cpu-moe"
                (toString cfg.cpuMoeLayers)
              ]
              ++ cfg.extraArgs
            );

            User = "llama-server";
            Group = "llama-server";
            SupplementaryGroups = [
              "video"
              "render"
            ];

            Restart = "on-failure";
            RestartSec = "5s";

            PrivateTmp = true;
            NoNewPrivileges = true;
            ProtectKernelTunables = true;
            ProtectControlGroups = true;
            ProtectKernelModules = true;
            RestrictNamespaces = true;
          };
        };
      };
    };
}
