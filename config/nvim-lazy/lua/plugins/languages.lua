return {
  {
    "ray-x/go.nvim",
    config = true,
    dependencies = {
      "ray-x/guihua.lua",
    },
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
  { "NoahTheDuke/vim-just" },
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