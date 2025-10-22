-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    signs_staged = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', '<leader>gn', function()
        if vim.wo.diff then
          vim.cmd.normal { '<leader>gn', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Next hunk/diff' })

      map('n', '<leader>gp', function()
        if vim.wo.diff then
          vim.cmd.normal { '<leader>gp', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Previous hunk/diff' })

      -- Actions
      map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
      map('n', '<leader>grh', gitsigns.reset_hunk, { desc = 'Reset hunk' })

      map('v', '<leader>gs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Stage hunk' })

      map('v', '<leader>grh', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Reset hunk' })

      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
      map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
      map('n', '<leader>gi', gitsigns.preview_hunk_inline, { desc = 'Preview hunk inline' })

      map('n', '<leader>gb', function()
        gitsigns.blame_line { full = true }
      end, { desc = 'Blame line' })

      -- Toggles
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle blame line' })
      map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = 'Toggle word diff' })

      -- Text object
      map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'Select hunk' })
    end,
  },
}
