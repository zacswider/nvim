return {
  'supermaven-inc/supermaven-nvim',
  event = 'InsertEnter',
  keys = {
    {
      '<leader>ta',
      function()
        local api = require 'supermaven-nvim.api'

        local function sync_blink_ghost_text(supermaven_enabled)
          local ok_ghost, ghost_text = pcall(require, 'blink.cmp.completion.windows.ghost_text')
          if not ok_ghost then
            return
          end

          if supermaven_enabled then
            ghost_text.clear_preview()
            return
          end

          local ok_list, list = pcall(require, 'blink.cmp.completion.list')
          if not ok_list or list.context == nil or #list.items == 0 then
            ghost_text.clear_preview()
            return
          end

          ghost_text.show_preview(list.context, list.items, list.selected_item_idx or 1)
        end

        api.toggle()

        if not api.is_running() then
          require('supermaven-nvim.completion_preview').on_dispose_inlay()
        end

        sync_blink_ghost_text(api.is_running())

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
