# AGENTS.md
For coding agents working in `/Users/zacswider/.config/nvim`.
This repo is a personal Neovim config written mostly in Lua and organized around `lazy.nvim`.

## Repo Layout
- `init.lua`: entrypoint; sets leaders, loads core modules, bootstraps `lazy.nvim`, registers plugin specs.
- `lua/core/*.lua`: editor options, keymaps, and small shared helpers.
- `lua/plugins/*.lua`: plugin specs and plugin-specific config.
- `lua/autocmds/*.lua`: autocmd modules loaded from `init.lua`.
- `after/`, `ftplugin/`: filetype-specific behavior.
- `.stylua.toml`: source of truth for Lua formatting.
- `lazy-lock.json`: pinned plugin versions; change intentionally.

## Cursor / Copilot Rules
No repo-local rule files were found:
- No `.cursorrules`
- No `.cursor/rules/`
- No `.github/copilot-instructions.md`
If any of those files are added later, treat them as higher-priority repo instructions and update this file.

## Environment
- Primary target is Neovim nightly; README calls out `>= 0.12`.
- Used on macOS and Linux.
- External tools may be required: `git`, `make`, `cargo`, `uv`, language toolchains.
- Mason installs many editor-side tools automatically, but not every CLI used by plugin build steps.

## Build / Bootstrap Commands
### Start Neovim
```bash
nvim
```
### Sync or install plugins
```bash
nvim --headless "+Lazy! sync" +qa
```
Use after changing `init.lua` or plugin specs in `lua/plugins/*.lua`.
### Update remote plugins
```bash
nvim --headless "+UpdateRemotePlugins" +qa
```
Useful for remote-plugin integrations such as `molten-nvim`.
### Basic startup smoke test
```bash
nvim --headless +qa
```
### Open one file and quit headlessly
```bash
nvim --headless path/to/file.lua +qa
```
Useful for targeted startup or filetype checks.

## Formatting Commands
### Format the repo
```bash
stylua .
```
### Format one file
```bash
stylua lua/plugins/lsp.lua
```
Stylua settings from `.stylua.toml`:
- 2-space indentation
- line width 160
- Unix line endings
- single quotes preferred when possible
- omit call parentheses where Lua/Stylua allows it

## Lint / Validation Commands
There is no dedicated repo-wide lint command checked into this repository.
Use these practical validation commands instead.
### Parse-check one Lua file
```bash
luac -p lua/plugins/lsp.lua
```
### Parse-check all Lua files
```bash
rg --files -g '*.lua' | xargs -n 1 luac -p
```
### Neovim health check
```bash
nvim --headless "+checkhealth" +qa
```
Useful after changing plugin integrations or external-tool setup.

## Test Commands
There is no formal automated test suite in this repository.
No `tests/`, `spec/`, `busted`, `plenary.nvim` test harness, CI workflow, `Makefile`, or package-script test runner was found.
Treat testing here as:
- startup smoke checks
- syntax checks
- targeted manual verification in Neovim
- plugin sync/update when plugin specs changed
### Closest equivalent to a repo test run
```bash
nvim --headless "+Lazy! sync" +qa && nvim --headless +qa
```
### Closest equivalent to a single test
There is no true single-test command because no test harness exists.
Use the narrowest useful check for the file or behavior you changed:
```bash
luac -p path/to/file.lua
```
```bash
stylua path/to/file.lua
```
```bash
nvim --headless path/to/file.lua +qa
```

## Code Style Guidelines
Follow nearby code before introducing new patterns. This codebase prefers small, direct Lua modules.

### Module Structure
- Plugin config files usually `return { ... }` directly as lazy.nvim plugin specs.
- Shared helper modules usually use `local M = {}` and `return M`.
- Keep helper functions local unless intentionally exported.
- Prefer one focused module per plugin or concern.

### Imports / Requires
- Prefer `require 'module.path'` for simple imports.
- Prefer `require('module').fn` only when chaining is clearer.
- Keep `require` calls close to use unless they are obvious module-level dependencies.
- Use `pcall(require, '...')` when a dependency may be optional or lazily loaded.
- Cache frequently used modules into locals like `local dap = require 'dap'`.

### Formatting
- Run `stylua` after edits.
- Use 2-space indentation in Lua source.
- Prefer single quotes unless double quotes are clearer.
- Keep code readable; the configured width is 160.
- Match existing Stylua-friendly style such as `require 'lazy'`.

### Types / Annotations
- LuaLS annotations are used sparingly.
- Keep existing annotations like `---@type ...` or `---@module ...` when editing those sections.
- Do not add verbose annotations everywhere.
- `vim` is intentionally treated as a global in LuaLS settings.

### Naming
- Use `snake_case` for locals and helper functions.
- Use short descriptive locals for common modules like `dap`, `dapui`, `builtin`, and `opts`.
- Exported names are concise and usually verb-oriented.
- Avoid class-like abstractions and deep object patterns.

### Control Flow
- Prefer straightforward imperative Lua.
- Use early returns for invalid states.
- Keep functions compact unless a larger block is clearer.
- Extract a helper only when reused or meaningfully clearer.

### Error Handling
- Guard optional plugin access with `pcall`.
- For non-fatal issues, prefer `vim.notify(...)` or `vim.api.nvim_echo(...)` over throwing.
- For startup-critical failures, `error(...)` is acceptable; `init.lua` does this for `lazy.nvim` clone failure.
- When using `vim.system(...):wait()`, check `result.code` and surface actionable warnings.
- Avoid crashing Neovim for recoverable plugin-specific failures.

### Comments
- Keep comments concise and useful.
- Preserve comments that explain load order, capability merging, or runtime behavior.
- Do not add comments for obvious assignments.

### Keymaps / Autocmds / API Usage
- Follow existing `vim.keymap.set(...)` style.
- Add `desc` for non-trivial mappings.
- Reuse a local `opts` table when many mappings share the same options.
- For autocmds, use named augroups via `vim.api.nvim_create_augroup(...)`.
- Prefer modern Neovim APIs already used here: `vim.api`, `vim.lsp`, `vim.system`, `vim.fs`, `vim.uv`.

## Practical Editing Advice
- Check nearby files before adding abstractions.
- Preserve manual comments and intentional load-order notes.
- Be careful with global options and keymaps; small changes can affect the whole editor.
- Prefer additive, local edits over broad refactors.
- If a change affects startup or plugin installation, run a headless smoke check.
- If a change affects Lua syntax or formatting, run `stylua` and `luac -p` on touched files.

## Default Approach
Use the smallest safe change, stay consistent with the existing lazy.nvim/Lua style, and verify with headless Neovim startup plus targeted syntax/format checks.
