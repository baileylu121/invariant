-- Noice: UI components for messages, cmdline, and popups
return {
  'noice.nvim',
  event = 'UIEnter',
  dependencies = {
    'nui.nvim',
    'plenary.nvim',
  },
  after = function()
    require('noice').setup {
      messages = {
        enabled = true,
        view = 'notify',
        view_error = 'notify',
        view_warn = 'notify',
        view_history = 'messages',
      },
      popupmenu = {
        enabled = true,
        backend = 'nui',
      },
      notify = {
        enabled = true,
        view = 'notify',
      },
      lsp = {
        progress = {
          enabled = true,
          ---@type 'lsp' | 'mini' | 'notification'
          format = 'lsp',
          ---@type 'message' | 'client'
          format_done = 'message',
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          view = nil,
        },
        signature = {
          enabled = true,
          view = nil,
        },
        message = {
          enabled = true,
          view = 'notify',
        },
      },
      markdown = {
        hover = {
          ['|(%S-)|'] = vim.cmd.help,
          ['%[.-%]%((%S-)%)'] = vim.cmd.help,
        },
      },
      health = {
        checker = true,
      },
      throttle = 1000,
      views = {},
      commands = {
        all = {
          view = 'popup',
          opts = { enter = true, format = 'details' },
        },
        history = {
          view = 'split',
          opts = { enter = true, format = 'details' },
        },
        last = {
          view = 'popup',
          opts = { enter = true, format = 'details' },
        },
        error = {
          view = 'popup',
          opts = { enter = true, format = 'details' },
        },
      },
      cmdline = {
        enabled = true,
        view = "cmdline",
      },
    }
  end,
}
