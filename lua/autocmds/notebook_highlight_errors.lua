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

-- Suppress treesitter error messages
vim.api.nvim_create_autocmd('User', {
  pattern = 'VimEnter',
  callback = function()
    -- Override treesitter error handler to be less noisy
    local original_notify = vim.notify
    vim.notify = function(msg, level, opts)
      if type(msg) == 'string' and msg:match('treesitter') and msg:match('Invalid.*index') then
        return -- Suppress this specific error
      end
      original_notify(msg, level, opts)
    end
  end,
})