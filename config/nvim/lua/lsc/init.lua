require('lsc.plugins')
require('lsc.nvimtree')
require('lsc.telescope')
require('lsc.lspconfig')
require('lsc.options')
require('lsc.keymaps')
require('lsc.colorscheme')

local M = {}

function M.create_autogroup(autocmds, name)
	cmd('augroup' .. name)
	cmd('autocmd!')
	for _, autocmd in ipairs(autocmds) do
		cmd('autocmd ' .. table.concat(autocmd, ''))
	end
	cmd('augroup END')
end
function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
