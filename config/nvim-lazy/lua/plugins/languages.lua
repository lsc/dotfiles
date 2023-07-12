return {
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
    "NoahTheDuke/vim-just",
  },
  { "cappyzawa/starlark.vim" },
}
