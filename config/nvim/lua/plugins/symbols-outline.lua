return {
  {
    "stevearc/aerial.nvim",
    config = true,
    cmd = "AerialToggle",
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
    cmd = "SymbolsOutline",
    keys = {
      { "<leader>a", ":SymbolsOutline <cr>", desc = "Toggle Symbols Outline" },
    },
    opts = {
      keymaps = {},
    },
  },
}
