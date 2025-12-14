{
  lib,
  flake-parts-lib,
  self,
  ...
}:
let
  inherit (lib) types mkOption;
  inherit (flake-parts-lib) mkPerSystemOption;
in
{
  options.perSystem = mkPerSystemOption (
    { pkgs, ... }:
    {
      options.invariant.neovim = {
        configRoot = mkOption {
          description = ''
            Neovim config root
          '';
          type = types.path;
          default = ./neovim/src;
        };
        plugins = mkOption {
          description = ''
            Neovim plugins to install into the packpath.
          '';
          type = types.listOf types.package;
          default = with pkgs.vimPlugins; [
            lz-n

            transparent-nvim

            telescope-nvim
            telescope-zoxide
            telescope-fzf-native-nvim
            telescope-ui-select-nvim
            nvim-web-devicons

            lualine-nvim

            oil-nvim

            gitsigns-nvim
            lazygit-nvim

            which-key-nvim

            mini-nvim
            plenary-nvim

            nvim-lspconfig
            fidget-nvim

            nvim-treesitter
            todo-comments-nvim

            nvim-cmp
            luasnip
            cmp_luasnip
            cmp-nvim-lsp
            cmp-path

            conform-nvim

            vim-sleuth

            startup-nvim

            lazy-lsp-nvim
            direnv-vim
          ];
        };
      };
    }
  );

  config = {
    perSystem =
      { pkgs, config, ... }:
      let
        cfg = config.invariant.neovim;
      in
      {
        packages.neovim =
          let
            packpath = pkgs.runCommandLocal "packpath" { } ''
              mkdir -p $out/pack/neovim/{start,opt}

              ${pkgs.lib.concatMapStringsSep "\n" (
                plugin: "ln -vsfT ${plugin} $out/pack/neovim/start/${pkgs.lib.getName plugin}"
              ) cfg.plugins}
            '';
          in
          pkgs.writeShellApplication {
            name = "nvim";

            runtimeInputs = with pkgs; [
              neovim-unwrapped

              git
              ripgrep
              fd
              nodejs
              zoxide
              direnv
              tree-sitter
              lazygit
            ];

            text = ''
              exec nvim "$@" \
                --cmd 'set packpath^=${packpath} | set rtp^=${packpath}' \
                --cmd 'set rtp^=${cfg.configRoot}' \
                -u '${cfg.configRoot}/init.lua'
            '';
          };
      };

    flake.modules.homeManager.neovim =
      { pkgs, ... }:
      let
        inherit (pkgs.stdenv.hostPlatform) system;
        inherit (self.packages.${system}) neovim;
      in
      {
        home.sessionVariables.EDITOR = lib.getExe neovim;
        home.packages = [ neovim ];
      };

    flake.modules.nixos.neovim =
      { pkgs, ... }:
      let
        inherit (pkgs.stdenv.hostPlatform) system;
        inherit (self.packages.${system}) neovim;
      in
      {
        environment.variables.EDITOR = lib.getExe neovim;
        environment.systemPackages = [ neovim ];
      };
  };
}
