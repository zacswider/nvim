-- Enable inlay hints by default for Rust files
vim.lsp.inlay_hint.enable(true)

-- Set Rust-specific options
vim.opt_local.textwidth = 100
vim.opt_local.colorcolumn = '100'
