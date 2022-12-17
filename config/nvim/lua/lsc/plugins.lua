-- Ensure Packer is installed and loaded.
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {'git', 'clone', '--depth=1', 'https://github.com/wbthomason/packer.nvim', install_path,}
  print "Installing packer and restart neovim"
  vim.cmd [[packadd packer.nvim ]]
end

-- Reload neovim when we save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use protected call so we don't error on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then return end

-- Packer uses a popup window
packer.init {
  display = {
    open_fn = function ()
      return require("packer.util").float { border = "rounded" }
    end
  },
}

-- Packages
return packer.startup(function(use)
  -- Utilities and libraries
  use	"nvim-lua/plenary.nvim"
  use "nvim-lua/popup.nvim"
  use	"ryanoasis/vim-devicons"
  use "windwp/nvim-autopairs"
  use "akinsho/bufferline.nvim"
  use "moll/vim-bbye"
  use "nvim-lualine/lualine.nvim"
  use "lewis6991/impatient.nvim"
  use "lukas-reineke/indent-blankline.nvim"
  use "folke/which-key.nvim"
  use "godlygeek/tabular"
  use "christoomey/vim-tmux-navigator"
  use {
    "junegunn/fzf",
    run = function()
      vim.fn['fzf#install']()
    end
  }
  use {
  "cshuaimin/ssr.nvim",
  module = "ssr",
  -- Calling setup is optional.
  config = function()
    require("ssr").setup {
      min_width = 50,
      min_height = 5,
      keymaps = {
        close = "q",
        next_match = "n",
        prev_match = "N",
        replace_all = "<leader><cr>",
      },
    }
  end
}

  -- Version Control
  use "lewis6991/gitsigns.nvim"
  use "TimUntersberger/neogit"

  -- Completion, Snippets and LSP
  use	"hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"
  use "hrsh7th/cmp-path"
  use "jose-elias-alvarez/null-ls.nvim"
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use "L3MON4D3/LuaSnip"
  use "rafamadriz/friendly-snippets"
  use "saadparwaiz1/cmp_luasnip"

  -- Navigation and search
  -- use	"kyazdani42/nvim-tree.lua"
  use	"kyazdani42/nvim-web-devicons"
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
  use {
    "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
        "MunifTanjim/nui.nvim"
      }
  }
  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-media-files.nvim"
  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = 'make', cond = vim.fn.executable 'make' == 1
  }
  use "ahmedkhalf/project.nvim"
  use 'goolord/alpha-nvim'
  use "stevearc/aerial.nvim"
  use {
    "s1n7ax/nvim-search-and-replace",
    config = function() require'nvim-search-and-replace'.setup() end,
  }
  use {
    's1n7ax/nvim-window-picker',
    tag = 'v1.*',
    config = function()
        require'window-picker'.setup()
    end,
  }

  -- Comments
  use "numToStr/Comment.nvim"
  use "JoosepAlviste/nvim-ts-context-commentstring"

  -- Hilighting/Treesitter
  use	{
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use "p00f/nvim-ts-rainbow"
  use "nvim-treesitter/playground"

  -- Terminal
  use "akinsho/toggleterm.nvim"

  -- Presentation plugins
  use "sotte/presenting.vim"

  -- Software development plugins
  use "ray-x/go.nvim"
  use "dag/vim-fish"
  use "hashivim/vim-terraform"
  use "udalov/kotlin-vim"
  use "mfussenegger/nvim-dap"
  use "leoluz/nvim-dap-go"
  use "rcarriga/nvim-dap-ui"
  use "theHamsta/nvim-dap-virtual-text"
  use "nvim-telescope/telescope-dap.nvim"

  -- Colorschemes
  use "LunarVim/colorschemes"
  use "LunarVim/darkplus.nvim"
  use "LunarVim/onedarker.nvim"
  use "PaideiaDilemma/penumbra.nvim"
  use "arcticicestudio/nord-vim"
  use({ "catppuccin/nvim",
  	as = "catppuccin"
  })
  use "folke/tokyonight.nvim"
  use "gruvbox-community/gruvbox"
  use "sainnhe/gruvbox-material"

  -- Plugin manager
  use "wbthomason/packer.nvim"

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
