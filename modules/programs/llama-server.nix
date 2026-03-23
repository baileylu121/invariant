{ lib, ... }:
let
  nemotron-cascade-2 =
    pkgs:
    pkgs.fetchurl {
      url = "https://huggingface.co/mradermacher/Nemotron-Cascade-2-30B-A3B-GGUF/resolve/main/Nemotron-Cascade-2-30B-A3B.IQ4_XS.gguf";
      hash = "sha256-1PJA8WYxV2PYbS2DNtyUE0RxGm5UfqsxGcxe/HpiHxU=";
    };

  mkLlamaServer =
    {
      pkgs,
    }:
    let
      model = nemotron-cascade-2 pkgs;
    in
    pkgs.writeShellApplication {
      name = "llama-server-nemotron";
      runtimeInputs = [ pkgs.llama-cpp ];
      runtimeEnv = {
        __NV_PRIME_RENDER_OFFLOAD = 1;
        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        GGML_CUDA_GRAPH_OPT = 1;
      };
      text = ''
        exec llama-server \
          --model ${model} \
          -c 65536 \
          --parallel 1 \
          --threads-batch 24 \
          -fa on \
          -fit on \
          --fit-target 512 \
          --cache-type-k q8_0 \
          --cache-type-v q8_0 \
          -t 12 \
          --temp 1.0 \
          --top-p 0.95 \
          "$@"
      '';
    };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.llama-server = mkLlamaServer { inherit pkgs; };
    };

  flake.modules.nixos.llama-server =
    { config, pkgs, ... }:
    let
      cfg = config.services.llama-server;
      llamaServer = mkLlamaServer {
        inherit pkgs;
        inherit (cfg) flashAttention;
      };
    in
    {
      options.services.llama-server = {
        enable = lib.mkEnableOption "llama.cpp llama-server with Nemotron-Cascade-2";

        flashAttention = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable flash attention. Reduces KV cache VRAM usage significantly.";
        };

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
          default = 65536;
          description = "Context window size in tokens.";
        };

        gpuLayers = lib.mkOption {
          type = lib.types.int;
          default = -1;
          description = "Number of model layers to offload to GPU. -1 offloads all layers.";
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
          description = "llama.cpp llama-server service user";
        };

        users.groups.llama-server = { };

        systemd.services.llama-server = {
          description = "llama.cpp llama-server (Nemotron Cascade 2 30B A3B)";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          serviceConfig = {
            ExecStart = lib.escapeShellArgs (
              [
                "${llamaServer}/bin/llama-server"
                "--host"
                cfg.host
                "--port"
                (toString cfg.port)
                "--ctx-size"
                (toString cfg.contextSize)
                "--n-gpu-layers"
                (toString cfg.gpuLayers)
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
