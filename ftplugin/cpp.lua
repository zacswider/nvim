local bufnr = vim.api.nvim_get_current_buf()
local filename = vim.api.nvim_buf_get_name(bufnr)

if filename == '' then
  return
end

local qf_efm = table.concat({
  '%f:%l:%c: warning: %m',
  '%f:%l:%c: error: %m',
  '%f:%l:%c: fatal error: %m',
  '%f:%l: warning: %m',
  '%f:%l: error: %m',
  '%f:%l: fatal error: %m',
}, ',')

local compile_on_save = vim.api.nvim_create_augroup('cpp-compile-on-save', { clear = false })

vim.api.nvim_create_autocmd('BufWritePost', {
  group = compile_on_save,
  buffer = bufnr,
  callback = function(event)
    local path = vim.api.nvim_buf_get_name(event.buf)
    if path == '' then
      return
    end

    vim.system({
      'clang++',
      '-Wall',
      '-Wextra',
      '-Wconversion',
      '-Wsign-conversion',
      '-fsyntax-only',
      path,
    }, { text = true }, function(result)
      vim.schedule(function()
        local lines = {}
        if result.stdout ~= '' then
          vim.list_extend(lines, vim.split(result.stdout, '\n', { trimempty = true }))
        end
        if result.stderr ~= '' then
          vim.list_extend(lines, vim.split(result.stderr, '\n', { trimempty = true }))
        end

        vim.fn.setqflist({}, ' ', {
          title = 'clang++ warnings',
          lines = lines,
          efm = qf_efm,
        })

        if #lines > 0 then
          vim.cmd 'cwindow'
        else
          vim.cmd 'cclose'
        end
      end)
    end)
  end,
})
