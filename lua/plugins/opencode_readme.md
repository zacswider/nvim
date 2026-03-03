# opencode.nvim

Integrates the [opencode](https://github.com/sst/opencode) AI assistant with Neovim, providing editor-aware context sharing, prompt execution, and real-time event handling.

Run `:checkhealth opencode` after first launch to verify setup.

## Quick Start

1. **Toggle the opencode terminal**: `<leader>ot`
2. **Ask about code under cursor**: `<leader>oa` (normal or visual mode)
3. **Select a built-in prompt or command**: `<leader>ox`

## Keymaps

| Key          | Mode | Action                                       |
| ------------ | ---- | -------------------------------------------- |
| `<leader>oa` | n, x | Ask opencode about current context (`@this`) |
| `<leader>ox` | n, x | Select opencode action / prompt / command    |
| `<leader>ot` | n, t | Toggle opencode terminal                     |
| `<S-C-u>`    | n    | Scroll opencode session up half page         |
| `<S-C-d>`    | n    | Scroll opencode session down half page       |

### Switching focus out of the terminal

Use the same split-navigation keys you use everywhere else — they work from inside the terminal too:

| Key     | Action                                          |
| ------- | ----------------------------------------------- |
| `<C-h>` | Leave terminal, move to the window on the left  |
| `<C-l>` | Leave terminal, move to the window on the right |
| `<C-k>` | Leave terminal, move to the window above        |
| `<C-j>` | Leave terminal, move to the window below        |

These are defined in `core/keymaps.lua` and handle the `<C-\><C-n>` escape internally so you never have to type it.

To jump back into the opencode terminal, focus its window and press `i` or `a`.

`<leader>ot` (bound in both `n` and `t` modes) hides/shows the window when you don't need it visible.

### Terminal Keymaps (inside the embedded opencode terminal)

These are set by opencode.nvim in the terminal buffer automatically:

| Key     | Action                      |
| ------- | --------------------------- |
| `<C-u>` | Scroll up half page         |
| `<C-d>` | Scroll down half page       |
| `gg`    | Jump to first message       |
| `G`     | Jump to last message        |
| `<Esc>` | Interrupt current operation |

## Contexts

Reference these placeholders in any prompt to inject editor context:

| Placeholder    | What it provides                                     |
| -------------- | ---------------------------------------------------- |
| `@this`        | Visual selection, operator range, or cursor position |
| `@buffer`      | Current buffer contents                              |
| `@buffers`     | All open buffers                                     |
| `@visible`     | Currently visible text                               |
| `@diagnostics` | LSP diagnostics for the current buffer               |
| `@quickfix`    | Quickfix list                                        |
| `@diff`        | Git diff                                             |
| `@marks`       | Global marks                                         |

## Built-in Prompts

Select these via `<leader>ox` or reference them by name in a prompt:

| Prompt        | What it does                                                |
| ------------- | ----------------------------------------------------------- |
| `diagnostics` | Explain current buffer diagnostics                          |
| `diff`        | Review the current git diff for correctness and readability |
| `document`    | Add documentation comments to the selected code             |
| `explain`     | Explain the selected code and its context                   |
| `fix`         | Fix diagnostics in the current buffer                       |
| `implement`   | Implement the selected stub/placeholder                     |
| `optimize`    | Optimize the selected code for performance and readability  |
| `review`      | Review the selected code for correctness and readability    |
| `test`        | Add tests for the selected code                             |

## Ask Input (`<leader>oa`)

- Press `<Up>` to browse recent asks.
- Press `<Tab>` to trigger context/subagent completion.
- End a prompt with `\n` to append to the session instead of submitting.
- When `snacks.input` is active:
  - `<S-CR>` appends instead of submitting.
  - Completions are provided via in-process LSP.

## Session Commands

Accessible via `<leader>ox` > Commands, or by calling `require("opencode").command(name)`:

| Command             | Description                            |
| ------------------- | -------------------------------------- |
| `session.new`       | Start a new session                    |
| `session.select`    | Switch to a different session          |
| `session.interrupt` | Interrupt the current response         |
| `session.compact`   | Compact session to reduce context size |
| `session.undo`      | Undo the last action                   |
| `session.redo`      | Redo the last undone action            |
| `session.share`     | Share the current session              |
| `agent.cycle`       | Cycle through available agents         |

## Events

opencode.nvim fires `OpencodeEvent` autocmds for all server-sent events:

```lua
vim.api.nvim_create_autocmd("User", {
  pattern = "OpencodeEvent:*",
  callback = function(args)
    local event = args.data.event
    if event.type == "session.idle" then
      vim.notify("opencode finished responding")
    end
  end,
})
```

- **File edits**: Buffers are automatically reloaded when opencode edits them (requires `vim.o.autoread = true`, already set).
- **Permissions**: When opencode requests a permission, you'll be prompted to approve or deny after the session goes idle.

## Statusline

The plugin exposes a statusline component. It is wired into lualine's `lualine_z` section automatically via `lualine.lua`.

## Running opencode manually

If you start opencode outside of Neovim, pass `--port` so the plugin can discover it:

```sh
opencode --port 4242
```

opencode.nvim will connect automatically; no restart required.
