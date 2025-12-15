{
  perSystem =
    { inputs', ... }:
    let
      pkgs = inputs'.nixpkgs-rust-wasi.legacyPackages;
    in
    {
      packages.zoxide-session-manager = pkgs.pkgsCross.wasi32.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "zoxide-session-manager";
        version = "0.4.1";

        nativeBuildInputs = [
          pkgs.lld
        ];

        cargoBuildFlags = [
          "--config"
          "target.wasm32-wasip1.rustflags=[\"-C\",\"linker=wasm-ld\"]"
        ];

        src = pkgs.fetchFromGitHub {
          owner = "liam-mackie";
          repo = "zsm";
          tag = "v${finalAttrs.version}";
          hash = "sha256-+W3l86MkqhklHLQbS9ODu6R4BqSKINyHCdjjO4nIBt0=";
        };

        cargoHash = "sha256-SxvEjYRzxgF6dCQb25TCkl8XHnKc8CI1TCSgVjoSXWg=";
      });
    };
}
