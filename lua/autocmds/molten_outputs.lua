-- Autocommands to import/export output chunks for .ipynb files

local imb = function(e) -- init molten buffer
  vim.schedule(function()
    local kernels = vim.fn.MoltenAvailableKernels()
    local try_kernel_name = function()
      local f = assert(io.open(e.file, 'r'))
      local content = f:read 'a'
      f:close()
      local metadata = vim.json.decode(content).metadata
      return metadata.kernelspec.name
    end
    local ok, kernel_name = pcall(try_kernel_name)
    if not ok or not vim.tbl_contains(kernels, kernel_name) then
      kernel_name = nil
      local venv = os.getenv 'VIRTUAL_ENV' or os.getenv 'CONDA_PREFIX'
      if venv ~= nil then
        kernel_name = string.match(venv, '/.+/(.+)')
      end
    end
    if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
      vim.cmd(('MoltenInit %s'):format(kernel_name))
    end
    vim.cmd 'MoltenImportOutput'
  end)
end

-- Import outputs when .ipynb buffers appear (including via :e or telescope)
vim.api.nvim_create_autocmd('BufAdd', {
  pattern = { '*.ipynb' },
  callback = imb,
})

-- Also handle nvim ./file.ipynb at startup
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.ipynb' },
  callback = function(e)
    if vim.api.nvim_get_vvar 'vim_did_enter' ~= 1 then
      imb(e)
    end
  end,
})

-- Export outputs to the .ipynb on write (if Molten is initialized)
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.ipynb' },
  callback = function()
    if require('molten.status').initialized() == 'Molten' then
      -- Use pcall to prevent the nbformat error from crashing nvim
      -- Silently handle any export errors - the notebook still saves correctly via jupytext
      pcall(function()
        vim.cmd 'MoltenExportOutput!'
      end)
    end
  end,
})
