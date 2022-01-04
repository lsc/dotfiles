require('lsc.nvimtree')
require('lsc.telescope')
require('lsc.lspconfig')

local M = {}
local opts = { noremap = true}
cmd = vim.cmd
map = vim.api.nvim_set_keymap

vim.g.mapleader = ' '

map('n', '<leader>t', ':NvimTreeToggle<cr>',  opts)
map('n', '<C-p>', ':Telescope find_files<cr>', opts)
map('n', '<leader>ff', ':Telescope find_files<cr>', opts)
map('n', '<leader>fg', ':Telescope live_grep<cr>', opts)
map('n', '<leader>fb', ':Telescope buffers<cr>', opts)
map('n', '<leader>fh', ':Telescope help_tags<cr>', opts)
map('n', '<leader><esc>', ':nohlsearch<cr>', opts)

cmd("colorscheme gruvbox-material")

function M.create_autogroup(autocmds, name)
	cmd('augroup' .. name)
	cmd('autocmd!')
	for _, autocmd in ipairs(autocmds) do
		cmd('autocmd ' .. table.concat(autocmd, ''))
	end
	cmd('augroup END')
end
function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
