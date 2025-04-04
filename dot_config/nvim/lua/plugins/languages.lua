return {
  { "khaveesh/vim-fish-syntax" },
  { "terramate-io/vim-terramate" },
  { "NoahTheDuke/vim-just" },
  { "cappyzawa/starlark.vim" },
  { "Glench/Vim-Jinja2-Syntax" },
  {
    "benomahony/uv.nvim",
    config = function()
      require("uv").setup()
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
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
    "apple/pkl-neovim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    setup = {
      ensure_installed = "pkl",
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
  },
}
