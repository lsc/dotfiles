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
  { "terramate-io/vim-terramate" },
  {
    "NoahTheDuke/vim-just",
  },
  { "cappyzawa/starlark.vim" },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "vmware-archive/salt-vim",
  },
  {
    "Glench/Vim-Jinja2-Syntax",
  },
  {
    "apple/pkl-neovim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    setup = {
      ensure_installed = "pkl",
      highlight = {
        enable = true,
      },
      ident = {
        enable = true,
      },
    },
  },
}
