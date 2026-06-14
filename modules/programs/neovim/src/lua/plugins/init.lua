-- Initialize plugins with no .setup() step
return {
  -- Detect tabstop and shiftwidth automatically
  { 'vim-sleuth',       event = 'DeferredUIEnter' },
  -- Transparent background
  { 'transparent-nvim', event = 'VimEnter' },
  -- Direnv support
  { 'direnv-vim',       event = 'DeferredUIEnter' },
  -- Lazygit
  { 'lazygit',          event = 'DeferredUIEnter' },
  -- Plenary
  { 'plenary.nvim',     event = 'DeferredUIEnter' },
  -- PI
  { 'pi.nvim',          event = 'DeferredUIEnter' },
  -- notifications
  { 'nvim-notify',      event = 'DeferredUIEnter' },
  -- nui
  { 'nui.nvim',         event = 'DeferredUIEnter' },
  -- noice
  { 'noice.nvim',       event = 'UIEnter' },
}
