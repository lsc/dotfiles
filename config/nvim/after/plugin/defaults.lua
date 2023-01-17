local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

vim.cmd [[colorscheme nord]]

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.scrolloff = 25
vim.opt.scrollback = 25
vim.opt.termguicolors = true

vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sa', ":Telescope aerial <CR>",  { desc = '[S]earch [A]erial' })

-- Navigate splits with ^hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Resize with ^arrows
vim.keymap.set("n", "<C-Up>", ":resize +2<cr>", opts)
vim.keymap.set("n", "<C-Down>", ":resize -2<cr>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<cr>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<cr>", opts)

vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)

vim.keymap.set('n', '<leader>e', ':Neotree toggle<cr>',  opts)
vim.keymap.set('n', '<leader>d', ':AerialToggle<cr>', opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Text manipulation
-- Normal mode
vim.keymap.set("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
vim.keymap.set("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Visual mode
vim.keymap.set("v", "<A-j>", ":m .+1<CR>==", opts)
vim.keymap.set("v", "<A-k>", ":m .-2<CR>==", opts)
vim.keymap.set("v", "p", '"_dP', opts)

-- Visual block
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal navigation
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
-- Leave terminal mode with ESC, so you can split the terminal
vim.keymap.set("t", "<ESC>", "<C-\\><C-N>", term_opts)
vim.keymap.set("n", '<leader>t', ":ToggleTermToggleAll<CR>", opts)

-- Lualine configuration to include aerial information
require('lualine').setup({
sections = {
    lualine_x = { "aerial" },
    -- Or you can customize it
    lualine_y = { "aerial",
      -- The separator to be used to separate symbols in status line.
      sep = ' ) ',
      -- The number of symbols to render top-down. In order to render only 'N' last
      -- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
      -- be used in order to render only current symbol.
      depth = nil,
      -- When 'dense' mode is on, icons are not rendered near their symbols. Only
      -- a single icon that represents the kind of current symbol is rendered at
      -- the beginning of status line.
      dense = { "false" },
      -- The separator to be used to separate symbols in dense mode.
      dense_sep = '.',
      -- Color the symbol icons.
      colored = { "true" },
    },
  },
})
