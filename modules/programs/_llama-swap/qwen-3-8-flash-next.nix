{
  inputs,
  system,
  pkgs,
  llama-swap-lib,
  ...
}:
let
  inherit (pkgs) lib;
  strata = inputs.strata-nix.packages.${system};
  hf = llama-swap-lib.fetchHuggingFace;

  strata-engine =
    (strata.strata-engine.override {
      cudaArch = "120";
      cudaPackages = pkgs.cudaPackages_13_0;
    }).overrideAttrs
      (old: {
        cmakeFlags = old.cmakeFlags ++ [
          "-DCMAKE_C_FLAGS=-march=znver5"
          "-DCMAKE_CXX_FLAGS=-march=znver5"
        ];
        preInstall = "rm ../bin/strata";
      });

  ista = "https://huggingface.co/ISTA-DASLab/Qwen3.8-Flash-Next-GSQ-RCO-GGUF/resolve/ed59f92082b1e93c0e96d60a8b11aab089b52f09/IQ3_XXS";
  shard1 = "Qwen3.8-Flash-Next-GSQ-RCO-IQ3_XXS-00001-of-00002.gguf";
  shard2 = "Qwen3.8-Flash-Next-GSQ-RCO-IQ3_XXS-00002-of-00002.gguf";

  flash-next = pkgs.linkFarm "qwen3.8-flash-next-iq3_xxs" {
    ${shard1} = hf {
      url = "${ista}/${shard1}";
      name = shard1;
      hash = "sha256-IZ6pKZAN+p7wkfOqRz/bpodLZfyzZSbX2FGsnpWFbRU=";
    };
    ${shard2} = hf {
      url = "${ista}/${shard2}";
      name = shard2;
      hash = "sha256-MWtG86Lb1oyQD0MTarlEn53MNyXf2MeUhHwgS8Fh4RM=";
    };
    "ple.gguf" = hf {
      url = "https://huggingface.co/Maximilian228/Qwen3.8-Flash-Next-NVFP4-GPTQ-Strata/resolve/640a1db97446ddd5e89d2b70ecd0297987192c93/ple-fp8.gguf";
      name = "ple-fp8.gguf";
      hash = "sha256-N/ibjOWjQlkydjJXxAIp7AJyOtKrFLS7/CakhvRyXJw=";
    };
  };

  flash-next-pack =
    pkgs.runCommand "qwen3.8-flash-next-iq3_xxs-pack"
      { nativeBuildInputs = [ strata.strata-serve.py ]; }
      ''
        HOME=$TMPDIR python3 ${strata.strata-serve.share}/tools/iq_pack.py --gguf ${flash-next}/${shard1} --out $out
      '';

  strata-config = pkgs.writers.writeJSON "strata-qwen3.8-flash-next.json" {
    exe = lib.getExe' strata-engine "strata";
    tokenizer = "${flash-next-pack}/tokenizer";
    model_name = "qwen3.8-flash-next-gsq-rco-iq3_xxs";
    log = "/dev/stderr";
    args = lib.cli.toCommandLine llama-swap-lib.llamaOptionFormat {
      pack = flash-next-pack;
      native = "${flash-next}/${shard1}";
      ple-gguf = "${flash-next}/ple.gguf";
      expert-profile = "${strata.strata-serve.share}/data/expert-profile.bin";
      expert-cache = "auto";
      prefill = "auto";

      draft = "dflash2";
      draft-model = pkgs.fetchurl {
        url = "https://github.com/Niko1221/Strata/releases/download/v0.2.12/qwen3.8-flash-next-dflash2.strata1.q4_0-selq4.pack";
        hash = "sha256-TfLlqytHwGSvvmYuFuTwZWmHcSXC0OISOkrHVSZsZkw=";
      };
      mtp-draft-vocab = "${strata.strata-serve.share}/data/draft_vocab_en.bin";
      draft-conf = 0.8;
      spec = 6;

      max-context = 262144;
      kv = "k8v4";
      kv-resident = 32768;
      resident-budget-gib = 24;
      memory-limit-mib = 47104;
    };
  };
in
{
  _class = "llama-swap";

  models."Qwen 3.8 Flash Next IQ3_XXS" = {
    cmd = llama-swap-lib.formatLlamaCmd {
      package = strata.strata-serve;
      exe = "strata-serve";

      args = {
        engine = "strata";
        config = strata-config;
        port = 16322;
      };

      env = {
        __NV_PRIME_RENDER_OFFLOAD = 1;
        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        STRATA_ADAPT_OVERLAP = 1;
      };
    };

    proxy = "http://localhost:16322";
  };
}
