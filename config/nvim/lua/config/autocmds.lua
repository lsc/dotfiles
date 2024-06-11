-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com//LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    require("swenv.api").auto_venv()
  end,
})
