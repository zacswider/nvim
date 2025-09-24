require('quarto').activate()

-- Adjust text width for notebooks
vim.opt_local.textwidth = 100 -- Wider text width for notebooks
vim.opt_local.colorcolumn = '100' -- Show column guide
vim.opt_local.wrap = true -- Enable line wrapping
vim.opt_local.linebreak = true -- Break at word boundaries
