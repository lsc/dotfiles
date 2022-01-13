local status_ok, _ = pcall(require, "lspconfig")

if not status_ok then
  vim.notify("Could not load LSPConfig")
  return
end
require("lsc.lsp.lsp-installer")
require("lsc.lsp.handlers").setup()
