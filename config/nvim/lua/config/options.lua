-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local o = vim.opt
o.scrolloff = 20
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
