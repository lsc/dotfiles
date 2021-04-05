--
local M = {}
local cmd = vim.cmd

function M.create_autogroup(autocmds, name)
	cmd('augroup' .. name)
	cmd('autocmd!')
	for _, autocmd in ipairs(autocmds) do
		cmd('autocmd ' .. table.concat(autocmd, ''))
	end
	cmd('augroup END')
end
