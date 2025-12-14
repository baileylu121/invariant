return {
  'oil.nvim',
  event = 'DeferredUIEnter',
  after = function()
    require('oil').setup {
      default_file_explorer = true,
      prompt_save_on_select_new_entry = true,
      watch_for_changes = true,
      view_options = {
        show_hidden = true,
      },
    }

    -- Enable navigating out of a file
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  end,
}
