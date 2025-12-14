return {
  'lazy-lsp.nvim',
  event = 'DeferredUIEnter',
  after = function()
    require('lazy-lsp').setup {
      use_vim_lsp_config = true,
      configs = {
        ['nil_ls'] = {
          settings = {
            ['nil'] = {
              formatting = { command = { 'alejandra' } },
            },
          },
        },
        ['rust_analyzer'] = {
          settings = {
            ['rust-analyzer'] = {
              checkOnSave = {
                command = 'clippy',
              },
            },
          },
        },
      },
    }
  end,
}
