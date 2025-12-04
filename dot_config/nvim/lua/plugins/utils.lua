return {
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = { { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" } },
    opts = { disable_commit_confirmation = true },
  },
  {
    "NicolasGB/jj.nvim",
  },
  {
    "evanphx/jjsigns.nvim",
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "f-person/git-blame.nvim",
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
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    ft = "markdown",
    opts = {
      workspaces = {
        {
          name = "Personal (Linux)",
          path = "~/Sources/Obsidian/",
        },
        {
          name = "Personal (MacOS)",
          path = "~/src/github.com/lsc/obsidian/",
        },
      },
    },
  },
}
