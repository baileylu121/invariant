-- Neovim syntax highlighting
return {
  'nvim-treesitter',
  event = 'DeferredUIEnter',
  after = function()
    local treesitter_parser_dir = '~/.treesitter'

    -- Look for parsers in this path
    vim.opt.rtp:append(treesitter_parser_dir)

    require('nvim-treesitter.configs').setup {
      ensure_installed = {},
      ignore_install = {},
      sync_install = false,
      auto_install = true,

      -- Store parsers at this path
      parser_install_dir = treesitter_parser_dir,

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gss',
          node_incremental = 'gsn',
          scope_incremental = 'gsa',
          node_decremental = 'gsp',
        },
      },

      modules = {},

      highlight = {
        enable = true,
      },
    }
  end,
}
