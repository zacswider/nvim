return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },

  -- use a release tag to download pre-built binaries
  version = 'v1.6.0',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },

      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
      ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

      -- ['<Tab>'] = {  -- sidekick autocompletion; trying to disable to see if it helps perf issues
      --   'snippet_forward',
      --   function() -- sidekick next edit suggestion
      --     return require('sidekick').nes_jump_or_apply()
      --   end,
      --   function() -- if you are using Neovim's native inline completions
      --     return vim.lsp.inline_completion.get()
      --   end,
      --   'fallback',
      -- },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },

      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      keyword = {
        range = 'prefix',
      },
      -- debounce_ms = 50,
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 50,
      },
      ghost_text = {
        enabled = true,
      },
      trigger = {
        prefetch_on_insert = true,
        show_on_backspace = true,
        show_on_backspace_in_keyword = true,
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_accept_on_trigger_character = true,
        show_on_x_blocked_trigger_characters = { ' ', '\n', '\t' },
        show_in_snippet = false,
      },
      list = {
        max_items = 50,
        selection = { preselect = true, auto_insert = true },
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = {
        'lsp',
        -- 'snippets',
        'path',
        'buffer',
      },
      providers = {
        lsp = {
          name = 'LSP',
          module = 'blink.cmp.sources.lsp',
          score_offset = 1000, -- Prioritize LSP completions
          fallbacks = { 'buffer' },
          async = true,
          timeout_ms = 1500,
        },
        buffer = {
          name = 'Buffer',
          module = 'blink.cmp.sources.buffer',
          score_offset = -3, -- Lower priority for buffer completions
          min_keyword_length = 2, -- Only show buffer completions for longer words
        },
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = 'rust' },

    -- Enable signature help (experimental but essential for proper LSP experience)
    signature = {
      enabled = true,
      trigger = {
        enabled = true,
        show_on_trigger_character = true,
        show_on_insert_on_trigger_character = true,
      },
      window = {
        min_width = 20,
        max_width = 120,
        max_height = 20, -- Increased to accommodate multi-line formatting
        border = 'rounded',
        winblend = 0,
        show_documentation = true, -- Show both signature and documentation
        treesitter_highlighting = true,
        -- Custom drawing function for better parameter formatting
        -- draw = function(opts)
        --   -- Try to format parameters on separate lines
        --   local content = opts.content
        --   if content and type(content) == 'string' then
        --     -- Replace commas with newlines for better readability
        --     content = content:gsub(', ([%w_]+:)', ',\n  %1')
        --   end
        --   opts.content = content
        --   opts.default_implementation()
        -- end,
      },
    },
  },
  opts_extend = { 'sources.default' },
}
