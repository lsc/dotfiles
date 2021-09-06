local map = vim.api.nvim_set_keymap

-- Leader key mapping
map('n', '<SPACE>', '', {})
vim.g.mapleader = ' '

opts = { noremap = true }
map('n', '<C-p>', ':Telescope find_files<cr>', opts)
map('n', '<leader>ff', ':Telescope find_files<cr>', opts)
map('n', '<leader>fg', ':Telescope live_grep<cr>', opts)
map('n', '<leader>fb', ':Telescope buffers<cr>', opts)
map('n', '<leader>fh', ':Telescope help_tags<cr>', opts)
map('n', '<leader><esc>', ':nohlsearch<cr>', opts)
