-- Auto-attach treesitter highlighting for filetypes that have parsers
-- but aren't being auto-attached by nvim-treesitter (like community parsers)
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf = args.buf
    local ft = args.match

    -- Check if treesitter is already attached
    if vim.treesitter.highlighter.active[buf] then
      return
    end

    -- Try to get the corresponding treesitter language
    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then
      return
    end

    -- Try to get a parser for this language
    local has_parser, parser = pcall(vim.treesitter.get_parser, buf, lang)
    if not has_parser then
      return
    end

    -- Attach treesitter highlighting
    local ok, err = pcall(vim.treesitter.highlighter.new, parser)
    if not ok then
      vim.notify('Failed to attach treesitter for ' .. ft .. ': ' .. tostring(err), vim.log.levels.DEBUG)
    end
  end,
})
