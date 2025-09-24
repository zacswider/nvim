return {
  {
    'benlubas/molten-nvim',
    version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
    dependencies = { '3rd/image.nvim' },
    build = ':UpdateRemotePlugins',
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_max_height = 50 -- increased from 20
      vim.g.molten_virt_lines_off_by_1 = true -- make it so the output shows up below the \`\`\` delimiter
      vim.g.molten_wrap_output = true
      vim.g.molten_auto_open_output = false
      vim.keymap.set('n', '<localleader>eo', ':MoltenEvaluateOperator<CR>', { desc = 'evaluate operator', silent = true })
      vim.keymap.set('n', '<localleader>os', ':noautocmd MoltenEnterOutput<CR>', { desc = 'open output window', silent = true })
      vim.keymap.set('n', '<localleader>rr', ':MoltenReevaluateCell<CR>', { desc = 're-eval cell', silent = true })
      vim.keymap.set('v', '<localleader>r', ':<C-u>MoltenEvaluateVisual<CR>gv', { desc = 'execute visual selection', silent = true })
      vim.keymap.set('n', '<localleader>oh', ':MoltenHideOutput<CR>', { desc = 'close output window', silent = true })
      vim.keymap.set('n', '<localleader>md', ':MoltenDelete<CR>', { desc = 'delete Molten cell', silent = true })
      vim.keymap.set('n', '<localleader>mi', ':MoltenInterrupt<CR>', { desc = 'interrupt running cell', silent = true })
    end,
  },
  {
    -- see the image.nvim readme for more information about configuring this plugin
    '3rd/image.nvim',
    opts = {
      backend = 'kitty', -- whatever backend you would like to use
      max_width = 400,
      max_height = 400,
      max_height_window_percentage = 80,
      max_width_window_percentage = 80,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
      -- Add more image.nvim options for better display
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { 'markdown', 'vimwiki' },
        },
      },
    },
  },
  {
    {
      'quarto-dev/quarto-nvim',
      ft = { 'quarto', 'markdown' }, -- activate for both quarto and markdown files
      dependencies = {
        'jmbuhr/otter.nvim',
        'nvim-treesitter/nvim-treesitter',
      },
      config = function()
        require('quarto').setup {
          lspFeatures = {
            -- NOTE: put whatever languages you want here:
            languages = { 'python', 'rust' },
            chunks = 'all',
            diagnostics = {
              enabled = true,
              triggers = { 'BufWritePost' },
            },
            completion = {
              enabled = true,
            },
          },
          keymap = {
            -- NOTE: setup your own keymaps:
            hover = 'H',
            definition = 'gd',
            rename = '<leader>rn',
            references = 'gr',
            format = '<leader>gf',
          },
          codeRunner = {
            enabled = true,
            default_method = 'molten',
          },
        }

        local runner = require 'quarto.runner'
        vim.keymap.set('n', '<localleader>rc', runner.run_cell, { desc = 'run cell', silent = true })
        vim.keymap.set('n', '<localleader>ra', runner.run_above, { desc = 'run cell and above', silent = true })
        vim.keymap.set('n', '<localleader>rA', runner.run_all, { desc = 'run all cells', silent = true })
        vim.keymap.set('n', '<localleader>rl', runner.run_line, { desc = 'run line', silent = true })
        vim.keymap.set('v', '<localleader>r', runner.run_range, { desc = 'run visual range', silent = true })
        vim.keymap.set('n', '<localleader>RA', function()
          runner.run_all(true)
        end, { desc = 'run all cells of all languages', silent = true })
      end,
    },
  },
  {
    'GCBallesteros/jupytext.nvim',
    config = function()
      require('jupytext').setup {
        style = 'markdown',
        output_extension = 'md',
        force_ft = 'markdown',
      }
    end,
    -- Depending on your nvim distro or config you may need to make the loading not lazy
    lazy = false,
  },
}
