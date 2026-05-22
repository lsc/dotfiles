return {
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = { { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" } },
    opts = { disable_commit_confirmation = true },
  },
  {
    "NicolasGB/jj.nvim",
  },
  {
    "evanphx/jjsigns.nvim",
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "f-person/git-blame.nvim",
  },
  {
    "benomahony/uv.nvim",
    opts = {
      picker_integration = true,
    },
  },
  {
    "mistweaverco/kulala.nvim",
  },
}
