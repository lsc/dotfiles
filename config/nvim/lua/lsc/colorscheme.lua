vim.cmd "colorscheme default"
vim.g.tokyonight_style = "night"
vim.g.tokyonight_lualine_bold = true

local colorscheme = "gruvbox-material"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status_ok then
  vim.notify("Colorscheme " .. colorscheme .. "not found!")
  return
end
