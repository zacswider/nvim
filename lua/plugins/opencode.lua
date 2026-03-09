return {
  'nickjvandyke/opencode.nvim',
  version = '*', -- Latest stable release
  dependencies = {
    {
      -- `snacks.nvim` integration is recommended, but optional
      ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
      'folke/snacks.nvim',
      optional = true,
      opts = {
        input = {}, -- Enhances `ask()`
        picker = { -- Enhances `select()`
          actions = {
            opencode_send = function(...)
              return require('opencode').snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any; goto definition on the type or field for details
    }

    vim.o.autoread = true -- Required for opts.events.reload

    -- Ask opencode about current context
    vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
      require('opencode').ask('@this: ', { submit = true })
    end, { desc = 'Ask opencode' })

    -- Select from opencode actions / prompts / commands
    vim.keymap.set({ 'n', 'x' }, '<leader>ox', function()
      require('opencode').select()
    end, { desc = 'Execute opencode action' })

    -- Toggle opencode terminal
    vim.keymap.set({ 'n', 't' }, '<leader>ot', function()
      require('opencode').toggle()
    end, { desc = 'Toggle opencode' })

    -- Scroll opencode session
    vim.keymap.set('n', '<S-C-k>', function()
      require('opencode').command 'session.half.page.up'
    end, { desc = 'Scroll opencode up' })
    vim.keymap.set('n', '<S-C-j>', function()
      require('opencode').command 'session.half.page.down'
    end, { desc = 'Scroll opencode down' })
  end,
}
