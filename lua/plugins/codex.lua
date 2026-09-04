return {
  'nwiizo/codex.nvim',
  cmd = {
    'Codex',
    'CodexPrompt',
    'CodexSendVisual',
  },
  keys = {
    { '<leader>oc', '<cmd>Codex<cr>', desc = 'Toggle Codex terminal' },
  },
  opts = {
    backend = 'terminal',
    terminal = {
      layout = 'split',
      split_side = 'right',
      split_width_percentage = 0.35,
      -- core.keymaps provides Ctrl-h/j/k/l navigation for every terminal buffer.
      window_navigation = false,
    },
  },
}
