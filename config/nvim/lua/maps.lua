local map = vim.api.nvim_set_keymap

-- Leader key mapping
map('n', '<SPACE>', '', {})
vim.g.mapleader = ' '

opts = { noremap = true }
map('n', '<C-p>', ':Files<cr>', opts)
map('n', '<leader><esc>', ':nohlsearch<cr>', opts)