return {
  { "rebelot/kanagawa.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "ribru17/bamboo.nvim" },
  { "polirritmico/monokai-nightasty.nvim" },
  { "mcchrish/zenbones.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  {
    "uloco/bluloco.nvim",
    dependencies = {
      "rktjmp/lush.nvim",
    },
  },
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
  {
    "hedyhli/outline.nvim",
    config = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>a", "<cmd>Outline<cr>", desc = "Toggle Outline" },
    },
    opts = {
      autofold_depth = 0,
      keymaps = {},
    },
  },
  {
    "Lilja/zellij.nvim",
    config = true,
    -- If you want to configure the plugin
    --[[
    config = function()
        require('zellij').setup({})
    end
    ]]
  },
}
