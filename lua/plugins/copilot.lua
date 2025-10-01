return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  dependencies = {
    'neovim/nvim-lspconfig', -- Ensure LSP config loads first
  },
  config = function()
    require('copilot').setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true, -- Hide when blink.cmp is active
        debounce = 75,
        keymap = {
          accept = '<M-l>', -- Alt+l to accept suggestion
          accept_word = '<M-w>', -- Alt+w to accept word
          accept_line = '<M-e>', -- Alt+e to accept line
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = '[[',
          jump_next = ']]',
          accept = '<CR>',
          refresh = 'gr',
          open = '<M-CR>'
        },
        layout = {
          position = 'bottom',
          ratio = 0.4
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ['.'] = false,
      },
      copilot_node_command = 'node', -- Use system node
      server_opts_overrides = {
        -- Ensure compatibility with the LSP server
        name = 'copilot',
      },
    })

    -- Set up autocmds to hide copilot suggestions when blink.cmp menu is open
    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuOpen',
      callback = function()
        vim.b.copilot_suggestion_hidden = true
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuClose',
      callback = function()
        vim.b.copilot_suggestion_hidden = false
      end,
    })
  end,
}