local status_ok, configs = pcall(require, "nvim-treesitter.configs")

if not status_ok then
  vim.notify("Unable to load Treesitter")
  return
end

configs.setup {
  ensure_installed = "maintained",
  sync_install = false,
  ignore_install = { "" },

  highlight = {
    enable = true,
    disable = { "" },
    additional_vim_regex_highlighting = true,
  },

  indent = { enable = true, disable = { "yaml" } },

  rainbow = {
    enable = true,
    -- disable = { "list", "of", "languages" }
    extended_mode = true,
    max_file_line = nil,
  },

  autopairs = {
    enable = true,
  },

  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}
