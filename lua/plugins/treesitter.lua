return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'lua',
        'python',
        'javascript',
        'typescript',
        'vimdoc',
        'vim',
        'regex',
        'terraform',
        'sql',
        'dockerfile',
        'toml',
        'json',
        'java',
        'groovy',
        'go',
        'gitignore',
        'graphql',
        'yaml',
        'make',
        'cmake',
        'markdown',
        'markdown_inline',
        'bash',
        'tsx',
        'css',
        'html',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          move = {
            enable = true,
            set_jumps = false,
            goto_next_start = {
              [']b'] = { query = '@code_cell.inner', desc = 'next code block' },
            },
            goto_previous_start = {
              ['[b'] = { query = '@code_cell.inner', desc = 'previous code block' },
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['ib'] = { query = '@code_cell.inner', desc = 'in block' },
              ['ab'] = { query = '@code_cell.outer', desc = 'around block' },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>sbl'] = '@code_cell.outer',
            },
            swap_previous = {
              ['<leader>sbh'] = '@code_cell.outer',
            },
          },
        },
      }
    end,
  },
}
