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
      cmdline = {
        enabled = true,           -- enables the Noice cmdline UI
        view = 'cmdline_popup',   -- view for the input (cmdline_popup, cmdline, etc.)
        opts = {},                -- options for the cmdline view
        format = {
          cmdline = { pattern = ':', icon = ' ', lang = 'vim' },
          search_down = { kind = 'search', pattern = '/', icon = '🔍 ', lang = 'regex' },
          search_up = { kind = 'search', pattern = '?', icon = '🔍 ', lang = 'regex' },
          filter = { pattern = ':%s*!', icon = ' ', lang = 'bash' },
          lua = { pattern = ':%s*lua%s+', icon = ' ', lang = 'lua' },
          help = { pattern = ':%s*he?l?p?%s+', icon = ' ', lang = 'vim' },
          input = { view = 'cmdline_input', icon = '󰥻 ' }, -- Used by :input command
        },
      },
      messages = {
        enabled = true,           -- enables the Noice messages UI
        view = 'notify',          -- default view for messages (notify, mini, popup, etc.)
        view_error = 'notify',    -- view for errors
        view_warn = 'notify',     -- view for warnings
        view_history = 'messages', -- view for :messages
      },
      popupmenu = {
        enabled = true,           -- enables the Noice popup menu
        ---@type 'nui' | 'cmp'
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
          -- override the default LSP markdown formatter with Noice
          -- Note: string keys are required — noice looks them up by name, not function ref
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          -- cmp.entry is lazy-loaded, so use the string name instead of require('cmp').entry
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          view = nil, -- uses default
        },
        signature = {
          enabled = true,
          view = nil, -- uses default
        },
        message = {
          enabled = true,
          view = 'notify',
        },
      },
      markdown = {
        hover = {
          ['|(%S-)|'] = vim.cmd.help,  -- :help links
          ['%[.-%]%((%S-)%)'] = vim.cmd.help, -- markdown links
        },
      },
      health = {
        checker = true,              -- enable health checks
      },
      throttle = 1000,               -- throttle for LSP progress messages (ms)
      views = {},                    -- custom views
      commands = {
        all = {
          -- options for the :Noice command
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
    }
  end,
}
