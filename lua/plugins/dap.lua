return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Python debugging support
    'mfussenegger/nvim-dap-python',
    -- Debug UI
    {
      'rcarriga/nvim-dap-ui',
      dependencies = { 'nvim-neotest/nvim-nio' },
    },
  },
  -- Define signs early (before plugin loads) so they're ready when breakpoints are set
  init = function()
    -- Use simple ASCII characters to ensure visibility
    vim.fn.sign_define('DapBreakpoint', { text = 'B', texthl = 'DiagnosticError', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = 'C', texthl = 'DiagnosticWarn', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = 'L', texthl = 'DiagnosticInfo', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '→', texthl = 'DiagnosticOk', linehl = 'CursorLine', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected', { text = 'R', texthl = 'DiagnosticError', linehl = '', numhl = '' })
  end,
  -- Define keys here so they're available immediately and will load the plugin when pressed
  -- NOTE: Arrow keys are context-aware in lua/core/keymaps.lua (DAP when debugging, resize otherwise)
  keys = {
    -- Session control
    { '<leader>dc', function() require('dap').continue() end, desc = 'Debug: [C]ontinue' },
    { '<leader>dq', function() require('dap').terminate() end, desc = 'Debug: [Q]uit/Terminate' },
    { '<leader>dR', function() require('dap').restart() end, desc = 'Debug: [R]estart' },
    { '<leader>dl', function() require('dap').run_last() end, desc = 'Debug: Run [L]ast' },
    -- Stepping (GDB-style alternatives)
    -- NOTE: <leader>ds is context-aware in lua/plugins/lsp.lua (DAP step when debugging, document symbols otherwise)
    { '<leader>dn', function() require('dap').step_over() end, desc = 'Debug: Step [N]ext (over)' },
    { '<leader>df', function() require('dap').step_out() end, desc = 'Debug: [F]inish (step out)' },
    { '<leader>dp', function() require('dap').pause() end, desc = 'Debug: [P]ause' },
    -- Breakpoints
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle [B]reakpoint' },
    { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Set Conditional [B]reakpoint' },
    { '<leader>dL', function() require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log point message: ') end, desc = 'Debug: Set [L]og Point' },
    { '<leader>dC', function() require('dap').clear_breakpoints() end, desc = 'Debug: [C]lear All Breakpoints' },
    { '<leader>dQ', function() require('dap').list_breakpoints() end, desc = 'Debug: List Breakpoints (Quickfix)' },
    -- REPL
    { '<leader>dr', function() require('dap').repl.toggle() end, desc = 'Debug: Toggle [R]EPL' },
    -- Widgets
    { '<leader>dh', function() require('dap.ui.widgets').hover() end, mode = { 'n', 'v' }, desc = 'Debug: [H]over (evaluate expression)' },
    { '<leader>dP', function() require('dap.ui.widgets').preview() end, mode = { 'n', 'v' }, desc = 'Debug: [P]review' },
    { '<leader>dw', function() local w = require 'dap.ui.widgets'; w.centered_float(w.frames) end, desc = 'Debug: Show Frames ([W]indow)' },
    { '<leader>dS', function() local w = require 'dap.ui.widgets'; w.centered_float(w.scopes) end, desc = 'Debug: Show [S]copes' },
    { '<leader>dt', function() local w = require 'dap.ui.widgets'; w.centered_float(w.threads) end, desc = 'Debug: Show [T]hreads' },
    -- Stack navigation
    { '<leader>du', function() require('dap').up() end, desc = 'Debug: Go [U]p in Stack' },
    { '<leader>dd', function() require('dap').down() end, desc = 'Debug: Go [D]own in Stack' },
    { '<leader>dg', function() require('dap').goto_() end, desc = 'Debug: [G]oto Line' },
    { '<leader>dj', function() require('dap').run_to_cursor() end, desc = 'Debug: Run to Cursor ([J]ump)' },
    -- DAP UI
    { '<leader>dU', function() require('dapui').toggle() end, desc = 'Debug: Toggle [U]I' },
    -- Python-specific
    { '<leader>dm', function() require('dap-python').test_method() end, desc = 'Debug: Test [M]ethod (Python)' },
    { '<leader>dK', function() require('dap-python').test_class() end, desc = 'Debug: Test Class (Python)' },
    { '<leader>dv', function() require('dap-python').debug_selection() end, mode = 'v', desc = 'Debug: Debug [V]isual Selection (Python)' },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Setup dap-ui with default layout
    dapui.setup()

    -- Auto open/close UI when debugging starts/ends
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- Setup nvim-dap-python
    -- Uses 'uv' which will automatically manage debugpy
    require('dap-python').setup 'uv'

    -- Add custom Python configurations
    table.insert(dap.configurations.python, {
      type = 'debugpy',
      request = 'launch',
      name = 'Panel serve',
      module = 'panel',
      args = { 'serve', '${file}', '--show' },
      cwd = '${workspaceFolder}',
      console = 'integratedTerminal',
    })
  end,
}
