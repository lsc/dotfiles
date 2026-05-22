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
    keys = {
      { "<leader>Rs", desc = "Send request" },
      { "<leader>Ra", desc = "Send all requests" },
      { "<leader>Rb", desc = "Open scratchpad" },
    },
    ft = { "http", "rest" },
    opts = {
      global_keymaps = false,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    },
  },
}
