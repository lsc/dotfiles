return {
  {
    "stevearc/aerial.nvim",
    config = true,
    keys = {
      { "<leader>m", ":AerialToggle<cr>", desc = "Toggle Aerial Outline" },
    },
    opts = {
      filter_kind = { false },
    },
  },
  {
    "simrat39/symbols-outline.nvim",
    config = true,
    keys = {
      { "<leader>a", ":SymbolsOutline <cr>", desc = "Toggle Symbols Outline" },
    },
    opts = {
      keymaps = {},
    },
  },
}
