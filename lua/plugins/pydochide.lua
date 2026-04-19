return {
  'camAtGitHub/pydochide.nvim',
  name = 'pydochide.nvim',
  ft = 'python',
  keys = {
    {
      '<leader>td',
      function()
        if vim.wo.foldenable then
          vim.cmd 'normal! zE'
          vim.wo.foldenable = false
          return
        end

        vim.wo.foldenable = true
        vim.cmd 'PyDocHide'
      end,
      desc = 'Toggle Python docstring hiding',
    },
  },
}
