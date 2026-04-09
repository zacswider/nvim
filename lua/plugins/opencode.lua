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
    local opencode_port = 4097
    local opencode_cmd = string.format('opencode --port %d', opencode_port)
    local terminal_opts = {
      split = 'right',
      width = math.floor(vim.o.columns * 0.35),
    }

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Pin the API port so opencode.nvim doesn't attach to a different Bun listener.
      server = {
        port = opencode_port,
        start = function()
          require('opencode.terminal').open(opencode_cmd, terminal_opts)
        end,
        stop = function()
          require('opencode.terminal').close()
        end,
        toggle = function()
          require('opencode.terminal').toggle(opencode_cmd, terminal_opts)
        end,
      },
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
    vim.keymap.set('n', '<leader>ot', function()
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
