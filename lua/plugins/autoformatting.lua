return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>tf',
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        if vim.g.disable_autoformat then
          vim.notify('Conform autoformat disabled', vim.log.levels.INFO)
        else
          vim.notify('Conform autoformat enabled', vim.log.levels.INFO)
        end
      end,
      mode = 'n',
      desc = 'Toggle autoformat',
    },
    {
      '<leader>fm',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = { 'n', 'x' },
      desc = 'Format buffer or range',
    },
    {
      '<leader>fd',
      function()
        if vim.bo.filetype ~= 'python' then
          vim.notify('Docstring formatting is only configured for Python files', vim.log.levels.WARN)
          return
        end
        require('conform').format {
          async = true,
          lsp_format = 'never',
          formatters = { 'docformatter', 'ruff_format' },
        }
      end,
      mode = 'n',
      desc = 'Format Python docstrings',
    },
  },
  opts = {
    notify_on_error = true,
    default_format_opts = {
      lsp_format = 'fallback',
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      local name = vim.api.nvim_buf_get_name(bufnr)
      if name:match '/node_modules/' then
        return
      end

      return {
        timeout_ms = 1500,
        lsp_format = 'fallback',
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_fix', 'docformatter', 'ruff_format' },
      rust = { 'rustfmt' },
      javascript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      json = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      yaml = { 'prettierd', 'prettier', stop_after_first = true },
      markdown = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      sh = { 'shfmt' },
      terraform = { 'terraform_fmt' },
    },
    formatters = {
      docformatter = {
        append_args = {
          '--pre-summary-newline',
          '--close-quotes-on-newline',
          '--wrap-summaries',
          '100',
          '--wrap-descriptions',
          '100',
        },
      },
      ruff_fix = {
        append_args = { '--extend-select', 'I' },
      },
    },
  },
  config = function(_, opts)
    require('conform').setup(opts)

    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = 'Disable format-on-save',
      bang = true,
    })

    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = 'Enable format-on-save',
    })
  end,
}
