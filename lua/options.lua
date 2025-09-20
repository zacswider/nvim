
-- this file opened every time nvim is loaded because init.lua is opened every time nvim is loaded and it imports
-- this file with the line `require 'options'`

-- enable line numbers
-- `vim` is a global variable. It is a lua table that is an interface to interact with nvim functionalities
-- `wo` is the "Windows Options" field within the `vim` table
-- `number` is the options to display line numbers
vim.wo.number = true
