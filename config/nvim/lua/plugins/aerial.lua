return {
  {
    "stevearc/aerial.nvim",
    keys = {
      { "<leader>a", ":AerialToggle<cr>", desc = "Toggle Aerial" },
    },
    config = true,
    opts = function()
      require("telescope").load_extension("aerial")
    end,
  },
}
