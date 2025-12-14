-- Enable gui config when inside neovide
if vim.g.neovide then
  require('transparent').toggle(false)
  require 'gui.display'
else
  require('transparent').toggle(true)
end
