local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("lsc.lsp.mason")
require("lsc.lsp.null-ls")
require("lsc.lsp.handlers").setup()
