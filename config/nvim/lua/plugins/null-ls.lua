return {
  "jose-elias-alvarez/null-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    local diagnostics = null_ls.builtins.diagnostics
    local formatting = null_ls.builtins.formatting
    null_ls.setup({
      sources = {
        diagnostics.markdownlint,
        diagnostics.shellcheck,
        diagnostics.vale,
        diagnostics.yamllint,
        diagnostics.checkmake,
        diagnostics.eslint_d,

        formatting.beautysh,
        formatting.eslint_d,
        formatting.fish_indent,
        formatting.fixjson,
        formatting.gofumpt,
        formatting.lua_format,
        formatting.markdownlint,
        formatting.shellharden,
        formatting.stylua,
        formatting.terraform_fmt,
        formatting.yamlfmt,
      },
    })
  end,
}
