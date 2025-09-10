return {
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
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "f-person/git-blame.nvim",
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
    "benomahony/uv.nvim",
    opts = {
      picker_integration = true,
    },
    {
      "linux-cultist/venv-selector.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
        "mfussenegger/nvim-dap",
        "mfussenegger/nvim-dap-python", --optional
        { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
      },
      ft = "python", -- Load when opening Python files
      keys = {
        { ",v", "<cmd>VenvSelect<cr>" }, -- Open picker on keymap
      },
      opts = { -- this can be an empty lua table - just showing below for clarity.
        search = {}, -- if you add your own searches, they go here.
        options = {}, -- if you add plugin options, they go here.
      },
    },
  },
}
