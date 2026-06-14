-- nvim-notify: fancy notification window
return {
  'nvim-notify',
  event = 'DeferredUIEnter',
  after = function()
    require('notify').setup({
      background_colour = '#000000',
    })
  end,
}
