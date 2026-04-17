return {
  'camAtGitHub/pydochide.nvim',
  name = 'pydochide.nvim',
  ft = 'python',
  keys = {
    {
      '<leader>td',
      function()
        vim.cmd 'PyDocHideToggle'
      end,
      desc = 'Toggle Python docstring hiding',
    },
  },
}
