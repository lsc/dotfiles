local status_ok, aerial = pcall(require, "aerial")

if not status_ok then return end

aerial.setup {}

local tele_status_ok, telescope = pcall(require, "telescope")
local lsp_status_ok, lspconfig = pcall(require, "lspconfig")

if not lsp_status_ok then
  return
end

if not tele_status_ok then
  return
end

telescope.load_extension('aerial')
lspconfig.vimls.setup{
  on_attach = require("aerial").on_attach
}

aerial.setup()
