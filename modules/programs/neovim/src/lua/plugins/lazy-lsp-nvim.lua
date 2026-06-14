return {
  'lazy-lsp.nvim',
  event = 'DeferredUIEnter',
  after = function()
    require('lazy-lsp').setup {
      use_vim_lsp_config = true,
      configs = {
        ['rust_analyzer'] = {
          settings = {
            ['rust-analyzer'] = {
              checkOnSave = 'clippy',
            },
          },
        },
      },
    }
  end,
}
