return {
  'supermaven-inc/supermaven-nvim',
  event = 'InsertEnter',
  keys = {
    {
      '<leader>ta',
      function()
        local api = require 'supermaven-nvim.api'
        api.toggle()

        if not api.is_running() then
          require('supermaven-nvim.completion_preview').on_dispose_inlay()
        end

        vim.notify(('Supermaven %s'):format(api.is_running() and 'enabled' or 'disabled'), vim.log.levels.INFO)
      end,
      desc = 'Toggle AI autocomplete',
      mode = 'n',
    },
  },
  config = function()
    require('supermaven-nvim').setup {
      disable_keymaps = true,
      ignore_filetypes = {
        TelescopePrompt = true,
      },
    }
  end,
}
