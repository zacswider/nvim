# DAP (Debug Adapter Protocol) Keybindings

This document summarizes the keybindings for `nvim-dap` and `nvim-dap-python`.

## Quick Start

1. **Set breakpoints**: `<leader>db` on lines you want to pause at
2. **Start debugging**: `<leader>dc` and select a configuration
3. **Step through code**: Use arrow keys or `<leader>d*` mappings
4. **Inspect variables**: `<leader>dh` to hover, `<leader>dS` to see all scopes
5. **Stop debugging**: `<leader>dq`

## Arrow Keys (Context-Aware)

Arrow keys are **context-aware**: they control DAP stepping when debugging, otherwise they resize windows.

| Key       | When Debugging | When Not Debugging     |
| --------- | -------------- | ---------------------- |
| `<Up>`    | Continue       | Resize window smaller  |
| `<Down>`  | Step Over      | Resize window larger   |
| `<Right>` | Step Into      | Vertical resize smaller|
| `<Left>`  | Step Out       | Vertical resize larger |

The stepping directions are intuitive: Down = next line, Right = go deeper, Left = go back.

## Session Control

| Key          | Action   | Meaning                             |
| ------------ | -------- | ----------------------------------- |
| `<leader>dc` | Continue | Start debugging or resume execution |
| `<leader>dq` | Quit     | Terminate the debug session         |
| `<leader>dR` | Restart  | Restart the current debug session   |
| `<leader>dl` | Run Last | Re-run the last debug configuration |

## Stepping (GDB-style Alternatives)

| Key          | Action    | Meaning                              |
| ------------ | --------- | ------------------------------------ |
| `<leader>dn` | Step Next | Same as `<Down>` (step over)         |
| `<leader>ds` | Step      | Same as `<Right>` (step into) *      |
| `<leader>df` | Finish    | Same as `<Left>` (step out)          |
| `<leader>dp` | Pause     | Pause execution of a running program |

These follow GDB debugger conventions where `n` = next, `s` = step, `f` = finish.

\* `<leader>ds` is **context-aware**: LSP Document Symbols when not debugging, DAP Step Into when debugging.

## Breakpoints

| Key          | Action                 | Meaning                                                      |
| ------------ | ---------------------- | ------------------------------------------------------------ |
| `<leader>db` | Toggle Breakpoint      | Add/remove a breakpoint on current line                      |
| `<leader>dB` | Conditional Breakpoint | Set a breakpoint that only triggers when a condition is true |
| `<leader>dL` | Log Point              | Set a point that logs a message instead of pausing           |
| `<leader>dC` | Clear All              | Remove all breakpoints                                       |
| `<leader>dQ` | List Breakpoints       | Show all breakpoints in quickfix window                      |

### Breakpoint Types Explained

- **Breakpoint**: Pauses execution when the line is reached
- **Conditional Breakpoint**: Pauses only when an expression evaluates to true (e.g., `i > 10`)
- **Log Point**: Prints a message to the debug console without pausing (e.g., `Value of x: {x}`)

## Debug UI

The debug UI (`nvim-dap-ui`) automatically opens when debugging starts and closes when it ends.

| Key          | Action    | Meaning                                      |
| ------------ | --------- | -------------------------------------------- |
| `<leader>dU` | Toggle UI | Manually open/close the full debug UI layout |

The UI shows:

- **Scopes** (top-left): Local variables and their values
- **Breakpoints** (left): All breakpoints in your project
- **Stacks** (left): Call stack showing function calls
- **Watches** (left): Custom expressions you're monitoring
- **REPL** (bottom): Interactive console for evaluating expressions
- **Console** (bottom): Program output

## Inspection (without full UI)

| Key          | Action      | Meaning                                                    |
| ------------ | ----------- | ---------------------------------------------------------- |
| `<leader>dr` | Toggle REPL | Open/close the debug console for evaluating expressions    |
| `<leader>dh` | Hover       | Show value of expression under cursor in a floating window |
| `<leader>dP` | Preview     | Show value in preview window                               |
| `<leader>dw` | Frames      | Show the call stack (which functions called which)         |
| `<leader>dS` | Scopes      | Show all variables in current scope                        |
| `<leader>dt` | Threads     | Show all running threads                                   |

### What These Mean

- **REPL**: An interactive console where you can type expressions to evaluate during debugging
- **Hover**: Quick peek at a variable's value
- **Frames**: The call stack showing the path of function calls that led to the current line
- **Scopes**: Variables organized by where they're defined (local, global, etc.)
- **Threads**: Useful for multi-threaded applications to see what each thread is doing

## Stack Navigation

| Key          | Action        | Meaning                                                       |
| ------------ | ------------- | ------------------------------------------------------------- |
| `<leader>du` | Up            | Move up the call stack (to the function that called this one) |
| `<leader>dd` | Down          | Move down the call stack (to the function this one called)    |
| `<leader>dg` | Goto          | Jump to a specific line (skipping code in between)            |
| `<leader>dj` | Run to Cursor | Continue execution until the cursor position is reached       |

## Python-Specific Keybindings

| Key          | Action          | Meaning                                              |
| ------------ | --------------- | ---------------------------------------------------- |
| `<leader>dm` | Test Method     | Debug the test method under cursor (pytest/unittest) |
| `<leader>dK` | Test Class      | Debug the entire test class under cursor             |
| `<leader>dv` | Debug Selection | Debug the visually selected code (visual mode)       |

## Python Debug Configurations

When you start debugging with `<leader>dc`, you'll be prompted to select a configuration:

| Configuration                | What it does                                                                                                                                                     |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Launch file`                | Run the current Python file from the beginning with the debugger attached. This is the most common choice for debugging a script.                                |
| `Launch file with arguments` | Same as above, but prompts you to enter command-line arguments (e.g., `--verbose --input data.csv`). Use this when your script expects `sys.argv` arguments.     |
| `Attach remote`              | Connect to an already-running Python process that was started with debugpy. Useful for debugging servers, long-running processes, or code running in containers. |
| `Run doctests in file`       | Execute and debug the doctests embedded in your Python file's docstrings. Stops at breakpoints within the doctest examples.                                      |
| `Panel serve`                | Launch the current file with `panel serve <file> --show`. Use this for debugging Panel/Bokeh dashboard applications.                                             |

### When to Use Each

- **Launch file**: Default choice for most debugging scenarios
- **Launch file with arguments**: When running CLI tools or scripts that need input parameters
- **Attach remote**: When debugging Flask/Django servers, Docker containers, or any process you can't restart easily
- **Run doctests**: When writing or debugging docstring examples
- **Panel serve**: When debugging Panel dashboard apps

#### How to attach

This is a simple example where the debugger attaches to a running webserver

1. In the code, set a breakpoint. Sometimes these need to be set in callbacks or panel won't hit
   them properly
2. In another terminal window, run `uv run python -Xfrozen_modules=off -m debugpy --listen 5678 --wait-for-client -m panel serve app.py --show`
3. In nvim, use `leader-dc` and select `attach` then the default localhost and port (5678) options
4. Refresh the browser to trigger the breakpoint if it didn't hit already

## Gutter Signs

| Sign | Meaning                              |
| ---- | ------------------------------------ |
| `B`  | Breakpoint set                       |
| `C`  | Conditional breakpoint               |
| `L`  | Log point                            |
| `→`  | Debugger stopped here (current line) |
| `R`  | Breakpoint rejected by debugger      |

## Prerequisites

- **Python debugging**: Requires `uv` (manages debugpy automatically)
- **Test debugging**: Requires tree-sitter parser for Python (`:TSInstall python`)
- **Attach remote**: Requires `debugpy` in your project (`uv add --dev debugpy`)
