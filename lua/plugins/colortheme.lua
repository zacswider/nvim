return {
  'Mofiqul/vscode.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    -- Set dark theme by default
    vim.o.background = 'dark'
    local theme_style = vim.o.background

    -- Toggle background transparency
    local bg_transparent = false

    local function setup_vscode()
      vim.o.background = theme_style
      local c = require('vscode.colors').get_colors()

      require('vscode').setup {
        style = theme_style,

        -- Enable transparent background
        transparent = bg_transparent,

        -- Enable italic comment
        italic_comments = true,

        -- Enable italic inlay type hints
        italic_inlayhints = true,

        -- Underline links
        underline_links = true,

        -- Disable nvim-tree background color when transparent
        disable_nvimtree_bg = bg_transparent,

        -- Apply theme colors to terminal
        terminal_colors = true,

        -- Override colors if needed
        color_overrides = {},

        -- Override highlight groups if needed
        group_overrides = {
          FloatBorder = { fg = '#ffffff', bg = c.vscPopupBack },
          BlinkCmpMenuBorder = { fg = '#ffffff', bg = c.vscPopupBack },
          BlinkCmpSignatureHelpBorder = { fg = '#ffffff', bg = c.vscPopupBack },
        },
      }

      -- Load the colorscheme
      require('vscode').load(theme_style)
    end

    -- Initial setup
    setup_vscode()

    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      setup_vscode()
    end

    local toggle_theme = function()
      theme_style = theme_style == 'dark' and 'light' or 'dark'
      setup_vscode()
    end

    vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>tl', toggle_theme, { noremap = true, silent = true })
  end,
}
