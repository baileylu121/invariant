-- WASM-first tree-sitter parser manager for Neovim 0.12+
return {
  'arborist-nvim',
  event = 'DeferredUIEnter',
  after = function()
    require('arborist').setup {
      install_popular = true,
    }
  end,
}
