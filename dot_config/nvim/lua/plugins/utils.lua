return {
  {
    "echasnovski/mini.align",
    version = false,
    opts = {},
  },
  {
    "s1n7ax/nvim-window-picker",
    opts = {
      tag = "v2.*",
    },
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = { { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" } },
    opts = { disable_commit_confirmation = true },
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
  {
    "f-person/git-blame.nvim",
  },
  {
    "AckslD/muren.nvim",
    config = true,
  },
  {
    "esensar/nvim-dev-container",
  },
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },
  {
    "nvim-neorg/neorg",
    dependencies = { "vhyrro/luarocks.nvim" },
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = true,
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "/mnt/c/Users/lsc/iCloudDrive/iCloud~md~obsidian/",
        },
      },
    },
  },
}
