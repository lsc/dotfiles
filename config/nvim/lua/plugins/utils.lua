return {
  {
    "akinsho/toggleterm.nvim",
    opts = {
      size = 10,
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = { border = "Normal", background = "Normal" },
      },
    },
  },
  {
    "s1n7ax/nvim-window-picker",
    opts = {
      tag = "v1.*",
    },
  },
  {
    "TimUntersberger/neogit",
    opts = {
      disable_commit_confirmation = true,
      keys = {
        { "<leader>gn", ":Neogit <cr>", desc = "Neogit" },
      },
    },
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
}