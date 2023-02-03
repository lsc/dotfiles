-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Leave terminal mode with ESC, so you can split the terminal
vim.keymap.set("t", "<ESC>", "<C-\\><C-N>", term_opts)
vim.keymap.set("n", "<leader>t", ":ToggleTermToggleAll<CR>", opts)
