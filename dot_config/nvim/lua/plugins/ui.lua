return {
  { "catppuccin/nvim", name = "catppuccin" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },
  {
    "folke/edgy.nvim",
    opts = {
      right = {
        {
          ft = "Outline",
          pinned = true,
          open = "Outline",
        },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      use_libuv_file_watcher = true,
      bind_to_cwd = true,
      window = {
        width = 600,
        mappings = {
          ["o"] = "open",
          ["l"] = "open_with_window_picker",
          ["s"] = "vsplit_with_window_picker",
          ["S"] = "split_with_window_picker",
          ["h"] = "close_node",
          ["W"] = "close_all_nodes",
        },
      },
    },
  },
}
