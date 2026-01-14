return {
  'lean.nvim',
  event = 'DeferredUIEnter',
  before = function()
    require('lz.n').trigger_load 'plenary.nvim'
  end,
  after = function()
    require('lean').setup { mappings = true }
  end,
}
