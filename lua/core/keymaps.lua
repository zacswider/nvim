-- Leaders are set in init.lua

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file with command-s like normal<D-s>
vim.keymap.set('n', '<D-s>', '<cmd>w<CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- Context-aware arrow keys: DAP stepping when debugging, window resize otherwise
local function dap_or_fallback(dap_fn, fallback_cmd)
  return function()
    local has_dap, dap = pcall(require, 'dap')
    if has_dap and dap.session() then
      dap_fn()
    else
      vim.cmd(fallback_cmd)
    end
  end
end

vim.keymap.set('n', '<Up>', dap_or_fallback(function() require('dap').continue() end, 'resize -2'), { noremap = true, silent = true, desc = 'Resize up / DAP continue' })
vim.keymap.set('n', '<Down>', dap_or_fallback(function() require('dap').step_over() end, 'resize +2'), { noremap = true, silent = true, desc = 'Resize down / DAP step over' })
vim.keymap.set('n', '<Right>', dap_or_fallback(function() require('dap').step_into() end, 'vertical resize -2'), { noremap = true, silent = true, desc = 'Resize right / DAP step into' })
vim.keymap.set('n', '<Left>', dap_or_fallback(function() require('dap').step_out() end, 'vertical resize +2'), { noremap = true, silent = true, desc = 'Resize left / DAP step out' })

-- Buffers
vim.keymap.set('n', '<leader><Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<leader><S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer

-- Window management
  vim.keymap.set('n', '<leader>sv', '<C-w>v', opts) -- split window vertically
  vim.keymap.set('n', '<leader>sh', '<C-w>s', opts) -- split window horizontally
  vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
  vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) --  go to previous tab

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- vim.keymap.set('n', '<leader>e', 'Neotree toggle', opts)  -- toggle neotree

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostics
vim.keymap.set('n', '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'open diagnostic float', noremap = true, silent = true })

-- Function navigation
vim.keymap.set('n', '<leader>ft', function() require('nvim-treesitter.textobjects.move').goto_previous_start('@function.outer') end, opts) -- jump to previous function top
vim.keymap.set('n', '<leader>fb', function() require('nvim-treesitter.textobjects.move').goto_next_end('@function.outer') end, opts) -- jump to next function bottom
vim.keymap.set('n', '<leader>kt', function() require('nvim-treesitter.textobjects.move').goto_previous_start('@class.outer') end, opts) -- jump to previous class top
vim.keymap.set('n', '<leader>kb', function() require('nvim-treesitter.textobjects.move').goto_next_end('@class.outer') end, opts) -- jump to next class bottom
