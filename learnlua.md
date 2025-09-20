# The `require` function

## How `require` works
Let's say I have a lua file `mod.lua`
In another lua file I have import `mod.lua` by writing
```lua
local mod = require('mod')
```

Under the hood, this is running something like the following.
```lua
local mod = ( function ()
    <contents of mod.lua>
)()
```
The result of this is that it's like the contents of mod.lua are the function
body, so any locals are invisible outside of it

so if `mod.lua` contains the following:
```lua
local M = {}

local function sayMyName()
    print('Swider')
end

function M.sayHello()
    print('Hello,')
    sayMyName()
end
return M
```

Then in the file where I `require` mod, I can run `mod.sayHello()`  -- prints "Hello, Swider"
but I can't run mod.sayMyName()

## How `require` works in neovim
- when you call `require 'modulename'` in lua, lua tries to find a `modulename.lua` (or compiled binary or dll) in a bunch of different places. For example:
    - ./modulename.lua
    - ./modulename/init.lua
    - /usr/local/share/lua/5.1/modulename.lua
    - etc
- neovim adds some stuff to the `runtimepath` such that if you have `~./config/nvim` as part of your `rtp`, and you `require 'mymodule'` it will look in
    - ~/.config/nvim/lua/mymodule.lua
    - othe rplaces too probably
- the lua/ directory creates a clear separation between your lua config files and other files in your ~/.config/nvim directory

## What if options imports something?
- Let's say you `~/.config/nvim/init.lua` file requires options.lua `require 'options'`
- It will looks for it in `~/.config/nvim/lua/options.lua`
- Let's say options needs stuff in another module
    - in `options.lua` you can collect funtionality from `~/.config/nvim/lua/utils/helpers.lua` with `local helpers = require('utils.helpers')`
        - note that this runs utils.helpers.lua and binds whatever it returns to the `helpers` variable.
        - when we ran `require 'options'` in `init.lua` previously we didn't bind the result to anything.
        - the expectation here is that it will run the commands in that file but not return anything

The init.lua file imports `options.lua` with the line `require 'options'`








