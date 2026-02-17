require('quarto').activate()

-- Adjust text width for notebooks
vim.opt_local.textwidth = 0 -- Disable auto hard-wrap while typing
vim.opt_local.colorcolumn = '100' -- Show column guide
vim.opt_local.wrap = true -- Enable line wrapping
vim.opt_local.linebreak = true -- Break at word boundaries
vim.opt_local.formatoptions:remove { 't' } -- No auto text wrapping in insert
