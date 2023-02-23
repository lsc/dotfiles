return {
  {
    "ray-x/go.nvim",
    config = true,
  },
  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
    end,
  },
  { "khaveesh/vim-fish-syntax" },
  {
    "nathom/filetype.nvim",
    opts = {
      overrides = {
        extensions = {
          tf = "terraform",
          tfvars = "terraform",
          tfstate = "json",
        },
      },
    },
  },
}
