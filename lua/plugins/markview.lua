return {
  'OXY2DEV/markview.nvim',
  lazy = false,

  -- For `nvim-treesitter` users.
  priority = 49,

  -- For blink.cmp's completion
  -- source
  dependencies = {
    'saghen/blink.cmp',
  },

  opts = {
    code_blocks = {
      style = 'language',
      position = nil,
      min_width = 100, -- Minimum width for code blocks
      pad_amount = 0, -- Padding around code blocks
      pad_char = ' ', -- Character used for padding

      language_direction = 'right',
      sign = true,
      sign_hl = nil,

      -- Language names removed due to deprecation warning
    },

    -- Configure inline code
    inline_codes = {
      enable = true,
      corner_left = '',
      corner_right = '',
      padding_left = ' ',
      padding_right = ' ',
    },

    -- Fix: Use markdown → headings instead of deprecated headings
    markdown = {
      headings = {
        enable = true,
        shift_width = 0,
        heading_1 = { style = 'icon' },
        heading_2 = { style = 'icon' },
        heading_3 = { style = 'icon' },
      },
    },
  },
}
