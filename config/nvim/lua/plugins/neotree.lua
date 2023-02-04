return {
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
}
