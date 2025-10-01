return {
  'folke/sidekick.nvim',
  opts = {
    cli = {
      mux = {
        enabled = false,
      },
    },
  },
  keys = {
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
        require('sidekick.cli').toggle { focus = true }
      end,
      desc = 'Sidekick Toggle CLI',
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
