return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters
    local biome_filetypes = {
      javascript = true,
      javascriptreact = true,
      typescript = true,
      typescriptreact = true,
    }

    local function is_biome_filetype(filetype)
      return biome_filetypes[filetype] == true
    end

    local function biome_root(bufnr)
      local path = vim.api.nvim_buf_get_name(bufnr)
      if path == '' then
        return nil
      end

      return vim.fs.root(path, { 'biome.json', 'biome.jsonc', 'package.json', '.git' })
    end

    local function biome_check_current_file(bufnr)
      local path = vim.api.nvim_buf_get_name(bufnr)
      if path == '' then
        return
      end

      local root = biome_root(bufnr)
      if not root then
        return
      end

      local result = vim.system({
        'bunx',
        'biome',
        'check',
        '--write',
        '--unsafe',
        '--no-errors-on-unmatched',
        '--files-ignore-unknown=true',
        path,
      }, { cwd = root }):wait()

      if result.code ~= 0 then
        vim.schedule(function()
          vim.notify(result.stderr ~= '' and result.stderr or 'Biome check reported issues on save', vim.log.levels.WARN)
        end)
      end

      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_call(bufnr, function()
              vim.cmd 'checktime'
            end)
          end
        end)
      end
    end

    -- Formatters & linters for mason to install
    require('mason-null-ls').setup {
      ensure_installed = {
        'prettier', -- ts/js formatter
        'eslint_d', -- ts/js linter
        'shfmt', -- Shell formatter
        'checkmake', -- linter for Makefiles
        'stylua', -- lua formatter; Already installed via Mason
        'ruff', -- Python linter and formatter; Already installed via Mason
        'biome', -- ts/js formatter/linter
      },
      automatic_installation = true,
    }

    -- Custom rustfmt with timeout to prevent hanging
    local rustfmt = {
      method = null_ls.methods.FORMATTING,
      filetypes = { 'rust' },
      generator = null_ls.formatter {
        command = 'rustfmt',
        args = { '--edition', '2021' },
        to_stdin = true,
        from_stderr = false,
        timeout = 5000,
      },
    }

    local sources = {
      diagnostics.checkmake,
      formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
      formatting.stylua,
      formatting.shfmt.with { args = { '-i', '4' } },
      formatting.terraform_fmt,
      rustfmt,
      require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
      require 'none-ls.formatting.ruff_format',
    }

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup {
      debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client:supports_method 'textDocument/formatting' and not is_biome_filetype(vim.bo[bufnr].filetype) then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false }
            end,
          })
        end
      end,
    }

    vim.api.nvim_create_autocmd('BufWritePost', {
      group = vim.api.nvim_create_augroup('BiomeCheckOnSave', { clear = true }),
      callback = function(args)
        if is_biome_filetype(vim.bo[args.buf].filetype) then
          biome_check_current_file(args.buf)
        end
      end,
    })
  end,
}
