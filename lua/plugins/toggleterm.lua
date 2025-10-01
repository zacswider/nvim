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
    config = function(_, opts)
      require("toggleterm").setup(opts)
      
      -- Terminal mode mappings for easier exit
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
    end,
  },
}

vim.keymap.set('n', '<leader>tt', '<Cmd>ToggleTerm<CR>')

return M