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
}
