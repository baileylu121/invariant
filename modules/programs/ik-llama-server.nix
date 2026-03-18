{ inputs, lib, ... }:
let
  omnicoder-9b =
    pkgs:
    pkgs.fetchurl {
      url = "https://huggingface.co/Tesslate/OmniCoder-9B-GGUF/resolve/main/omnicoder-9b-q4_k_m.gguf";
      hash = "sha256-VQ6PclPI4HmX+84lcNNyWbabDSH6935e1RjU7kxz2LM=";
    };

  mkLlamaServer =
    {
      pkgs,
      flashAttention ? true,
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      model = omnicoder-9b pkgs;
      cudaPkg = inputs.ik_llama.packages.${system}.cuda.overrideAttrs (old: {
        NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -march=znver5 -mtune=znver5";
      });
    in
    pkgs.writeShellApplication {
      name = "ik-llama-server";
      runtimeInputs = [ cudaPkg ];
      runtimeEnv = {
        __NV_PRIME_RENDER_OFFLOAD = 1;
        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };
      text = ''
        exec llama-server \
          --model ${model} \
          --flash-attn ${if flashAttention then "on" else "off"} \
          --cache-type-k q4_0 \
          --cache-type-v q4_0 \
          --threads 24 \
          --parallel 4 \
          --ctx-size 65536 \
          --reasoning-budget 0 \
          --gpu-layers 99 \
          --run-time-repack \
          --alias omnicoder-9b \
          --jinja \
          --ctx-checkpoints 0 \
          "$@"
      '';
    };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.ik-llama-server = mkLlamaServer { inherit pkgs; };
    };

  flake.modules.nixos.ik-llama-server =
    { config, pkgs, ... }:
    let
      cfg = config.services.ik-llama-server;
      llamaServer = mkLlamaServer {
        inherit pkgs;
        inherit (cfg) flashAttention;
      };
    in
    {
      options.services.ik-llama-server = {
        enable = lib.mkEnableOption "ik_llama.cpp llama-server with OmniCoder 9B";

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
          default = 131072;
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
          description = "ik_llama.cpp llama-server service user";
        };

        users.groups.llama-server = { };

        systemd.services.ik-llama-server = {
          description = "ik_llama.cpp llama-server (OmniCoder 9B)";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          serviceConfig = {
            ExecStart = lib.escapeShellArgs (
              [
                "${llamaServer}/bin/ik-llama-server"
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
