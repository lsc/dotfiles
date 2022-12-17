local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- SPACE is my LEADER key
keymap("", "<SPACE>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("n", "<LEADER>c", ":Bdelete<cr>", opts)

-- Navigate splits with ^hjkl
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with ^arrows
keymap("n", "<C-Up>", ":resize +2<cr>", opts)
keymap("n", "<C-Down>", ":resize -2<cr>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<cr>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<cr>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- File and symbol navigation
keymap('n', '<leader>e', ':Neotree toggle<cr>',  opts)
keymap('n', '<leader>d', ':AerialToggle<cr>', opts)

keymap('n', '<leader><esc>', ':nohlsearch<cr>', opts)

-- Exit INPUT mode with jk
keymap("i", "jk", "<ESC>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Text manipulation
-- Normal mode
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Visual mode
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual block
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Structured search and replace
keymap("x", "<leader>sr", 'function () require("ssr").open() end', opts)
keymap("n", "<leader>sr", 'function () require("ssr").open() end', opts)

-- Terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Telescope
keymap('n', "<leader>f", require('telescope.builtin').find_files, opts)
keymap('n', "<C-p>", require('telescope.builtin').find_files, opts)
keymap('n', '<leader>fg', require('telescope.builtin').grep_string, opts)
keymap('n', '<leader>fb', require('telescope.builtin').buffers, opts)
keymap('n', '<leader>fh', require('telescope.builtin').help_tags, opts)
keymap('n', '<leader>sd', require('telescope.builtin').diagnostics, opts)
keymap('n', '<leader>fi', function ()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer'})

-- Debugging
keymap("n", "<F5>", ":lua require'dap'.continue()<CR>", opts)
keymap("n", "<F10>", ":lua require'dap'.step_over()<CR>", opts)
keymap("n", "<F11>", ":lua require'dap'.step_into<CR>", opts)
keymap("n", "<F12>", ":lua require'dap'.step_out<CR>", opts)
keymap("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", opts)
keymap("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
keymap("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)
keymap("n", "<leader>dr", ":lua require'dap'.repl_open()<CR>", opts)

