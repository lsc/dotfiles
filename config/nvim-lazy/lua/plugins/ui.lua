return {
  { "rebelot/kanagawa.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "ribru17/bamboo.nvim" },
  {
    "uloco/bluloco.nvim",
    dependencies = {
      "rktjmp/lush.nvim",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "bamboo",
    },
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.defaults["<leader>t"] = { name = "+toggleterm" }
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      use_libuv_file_watcher = true,
      bind_to_cwd = true,
      window = {
        mappings = {
          ["o"] = "open_with_window_picker",
          ["l"] = "open_with_window_picker",
          ["s"] = "vsplit_with_window_picker",
          ["S"] = "split_with_window_picker",
          ["h"] = "close_node",
          ["W"] = "close_all_nodes",
        },
      },
    },
  },
  {
    "simrat39/symbols-outline.nvim",
    config = true,
    cmd = "SymbolsOutline",
    keys = {
      { "<leader>a", "<cmd>SymbolsOutline<cr>", desc = "Toggle Symbols Outline" },
    },
    opts = {
      autofold_depth = 0,
      keymaps = {},
    },
  },
}
