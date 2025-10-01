local M = {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      direction = 'float',
      float_opts = {
        border = 'curved',
      },
    },
  },
}

vim.keymap.set('n', '<leader>tt', '<Cmd>ToggleTerm<CR>')

return M