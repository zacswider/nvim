return {
  'folke/sidekick.nvim',
  event = 'VeryLazy', -- Load the plugin early so health check works
  opts = {
    -- add any options here
    cli = {
      mux = {
        backend = 'zellij',
        enabled = false,
      },
    },
  },
  keys = {
    -- Tab handling is now done in blink.cmp configuration
    {
      '<c-.>',
      function()
        require('sidekick.cli').focus()
      end,
      mode = { 'n', 'x', 'i', 't' },
      desc = 'Sidekick Switch Focus',
    },
    {
      '<leader>aa',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick Toggle CLI',
      mode = { 'n', 'v' },
    },
    {
      '<leader>as',
      function()
        require('sidekick.cli').select()
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
      end,
      desc = 'Sidekick Select CLI',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ap',
      function()
        require('sidekick.cli').prompt()
      end,
      desc = 'Sidekick Ask Prompt',
      mode = { 'n', 'v' },
    },
  },
}
