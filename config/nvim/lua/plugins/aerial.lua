return {
  {
    "stevearc/aerial.nvim",
    config = function()
      local telescope = require("telescope")
      telescope.load_extension("aerial")
    end,
  },
  vim.keymap.set("n", "<leader>a", ":AerialToggle <cr>"),
  vim.keymap.set("n", "<leader>sa", ":Telescope aerial <CR>", { desc = "[S]earch [A]erial" }),
}
