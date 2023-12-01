return {
  {
    "s1n7ax/nvim-window-picker",
    opts = {
      tag = "v1.*",
    },
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
    "declancm/maximize.nvim",
    keys = {
      { "<leader>wm", "<cmd>lua require('maximize').toggle()<cr>", desc = "Maximize currently focused window" },
    },
  },
  {
    "f-person/git-blame.nvim",
  },
  {
    "AckslD/muren.nvim",
    config = true,
  },
  {
    "coffebar/neovim-project",
    keys = {
      {
        "<leader>pd",
        "<cmd>Telescope neovim-project discover<cr>",
        desc = "Project discovery",
      },
      { "<leader>ph", "<cmd>Telescope neovim-project history<cr>", desc = "Project history" },
      { "<leader>pl", "<cmd>NeovimProjectLoadRecent<cr>", desc = "Load recent project" },
    },

    opts = {
      projects = { -- define project roots
        "~/Sources/work/*",
        "~/Sources/personal/*",
        "~/src/**",
        "~/.dotfiles/",
      },
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,
  },
}
