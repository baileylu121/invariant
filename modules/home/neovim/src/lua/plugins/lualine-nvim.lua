return {
  'lualine.nvim',
  event = 'UIEnter',
  after = function()
    require('lualine').setup {
      options = {
        theme = 'auto',
        icons_enabled = true,
        section_separators = { left = '', right = '' },
        component_separators = { left = '|', right = '|' },
        always_divide_middle = false,
      },
      sections = {
        lualine_a = {
          { 'mode', separator = { right = '' } },
        },
        lualine_b = {
          'branch',
          'diff',
          { 'diagnostics', sources = { 'nvim_lsp' } },
        },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = {
          { 'location', separator = { left = '' } },
        },
      },
    }
  end,
}
