-- Fix treesitter highlighting errors in notebooks
vim.api.nvim_create_autocmd({'TextChanged', 'TextChangedI'}, {
  pattern = {'*.md', '*.ipynb'},
  callback = function()
    -- Debounce treesitter updates to prevent rapid-fire errors
    vim.defer_fn(function()
      pcall(vim.treesitter.get_parser)
    end, 100)
  end,
})

-- Use a safer approach to handle treesitter errors without breaking molten
vim.api.nvim_create_autocmd('User', {
  pattern = 'VimEnter',
  callback = function()
    -- Set up a minimal error handler that doesn't interfere with communication
    vim.api.nvim_create_autocmd('CmdlineEnter', {
      callback = function()
        -- Just suppress the specific treesitter errors from being printed
        if vim.v.errmsg and vim.v.errmsg:match('treesitter.*Invalid.*index') then
          vim.v.errmsg = ""
        end
      end,
    })
  end,
})