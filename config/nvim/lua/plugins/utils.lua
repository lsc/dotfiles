return {
  {
    "s1n7ax/nvim-window-picker",
    opts = {
      tag = "v1.*",
    },
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = { { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" } },
    opts = { disable_commit_confirmation = true },
  },
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({})
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "declancm/maximize.nvim",
    keys = {
      { "<leader>wm", "<cmd>lua require('maximize').toggle()<cr>", desc = "Maximize currently focused window" },
    },
  },
  {
    "f-person/git-blame.nvim",
  },
  {
    "AckslD/muren.nvim",
    config = true,
  },
  {
    "mackeper/SeshMgr.nvim",
    opts = {},
    keys = {},
  },
  {
    "esensar/nvim-dev-container",
  },
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },
  {
    "nvim-neorg/neorg",
    dependencies = { "vhyrro/luarocks.nvim" },
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = true,
  },
}
