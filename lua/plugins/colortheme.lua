return {
  'Mofiqul/vscode.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    -- Set dark theme by default
    vim.o.background = 'dark'
    
    -- Toggle background transparency
    local bg_transparent = true

    local c = require('vscode.colors').get_colors()
    
    local function setup_vscode()
      require('vscode').setup({
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
        group_overrides = {}
      })
      
      -- Load the colorscheme
      vim.cmd.colorscheme "vscode"
    end

    -- Initial setup
    setup_vscode()

    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      setup_vscode()
    end

    vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
  end,
}
