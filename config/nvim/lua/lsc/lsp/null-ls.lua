local null_ls_status_ok, null_ls = pcall(require, "null-ls")

if not null_ls_status_ok then
  vim.notify("Unable to load null-ls")
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {

  sources = {
    diagnostics.chktex,
    diagnostics.gitlint,
    diagnostics.golangci_lint,
    diagnostics.jsonlint,
    diagnostics.markdownlint,
    diagnostics.shellcheck,
    diagnostics.yamllint,
    diagnostics.vale,

    formatting.chktex,
    formatting.golangci_lint,
    formatting.jsonlint,
    formatting.markdownlint,
    formatting.prettier.with { extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote"}},
    formatting.shellcheck,
    formatting.stylua,
    formatting.yamllint,

  },
}
