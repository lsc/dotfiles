return {
  { "rebelot/kanagawa.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },
  {
    "uloco/bluloco.nvim",
    dependencies = {
      "rktjmp/lush.nvim",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      use_libuv_file_watcher = true,
      bind_to_cwd = true,
      window = {
        mappings = {
          ["o"] = "open_with_window_picker",
          ["s"] = "vsplit_with_window_picker",
          ["S"] = "split_with_window_picker",
        },
      },
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
      autofold_depth = 0,
      keymaps = {},
    },
  },
  { "HiPhish/nvim-ts-rainbow2" },
}
