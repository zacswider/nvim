vim.wo.number = true -- Show line numbers
vim.o.relativenumber = true -- Show relative line numbers
vim.o.clipboard = 'unnamedplus' -- Sync clipboard between OS and nvim
vim.o.wrap = true -- Don't wrap long lines
vim.o.linebreak = true -- Don't split works; companion to wrap
vim.o.mouse = 'a' -- Enable mouse mode
vim.o.autoindent = true -- Keep the indentation of the previous line
vim.o.ignorecase = true -- Case-insensitive search unless \C or capital letter in search
vim.o.smartcase = true
vim.o.showmode = false -- We don't need to see things like -- INSERT -- anymore (default: true) b/c lualine handles this

vim.o.shiftwidth = 4 -- Number of spaces inserted per indentation
vim.o.tabstop = 4 -- Number of spaces inserted per tab
vim.o.softtabstop = 4 -- Number of spaces that a tab counts for while performing editing operations (default: 0)
vim.o.expandtab = true -- Convert tabs to spaces (default: false)

vim.o.scrolloff = 99 -- Minimal number of screen lines to keep above and below the cursor (default: 0)
vim.o.sidescrolloff = 0 -- Minimal number of screen columns either side of cursor if wrap is `false` (default: 0)

vim.o.cursorline = true -- Highlight the current line (default: false)
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#2a2a2a', blend = 30 })
  end,
})
vim.o.signcolumn = 'yes' -- Always show the sign column to prevent screen shifting (default: 'auto')

vim.o.splitbelow = true -- Force all horizontal splits to go below current window (default: false)
vim.o.splitright = true -- Force all vertical splits to go to the right of current window (default: false)

vim.o.updatetime = 250 -- Decrease update time (default: 4000)
vim.o.timeoutlen = 300 -- Time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)

vim.o.backup = false -- Creates a backup file (default: false)
vim.o.writebackup = false -- If a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited (default: true)
vim.o.undofile = true -- Save undo history (default: false)

vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience (default: 'menu,preview')
vim.opt.shortmess:append 'c' -- Don't give |ins-completion-menu| messages (default: does not include 'c')
vim.opt.iskeyword:append '-' -- Hyphenated words recognized by searches (default: does not include '-')
vim.opt.formatoptions:remove { 'c', 'r', 'o' } -- Don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode. (default: 'croql')

vim.opt.runtimepath:remove '/usr/share/vim/vimfiles' -- Separate Vim plugins from Neovim in case Vim still in use (default: includes this path if Vim is installed)

vim.opt.title = true -- Enable tab title
vim.opt.titlestring = [[nvim: %{fnamemodify(getcwd(), ':t')} (%{empty(bufname('%')) ? 'No Name' : expand('%:t')})]]
vim.lsp.inline_completion.enable()
