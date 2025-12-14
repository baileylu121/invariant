return {
  'todo-comments.nvim',
  event = 'DeferredUIEnter',
  after = function()
    require('todo-comments').setup()
  end,
}
