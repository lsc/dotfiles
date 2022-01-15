-- Ensure Packer is installed and loaded.
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path,}
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
if not status_ok then
  return
end

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
  use	"bronson/vim-trailing-whitespace"
  use "windwp/nvim-autopairs"
  use "akinsho/bufferline.nvim"
  use "moll/vim-bbye"
  use "nvim-lualine/lualine.nvim"
  use "lewis6991/impatient.nvim"
  use "lukas-reineke/indent-blankline.nvim"
  use "folke/which-key.nvim"

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
  use	"neovim/nvim-lspconfig"
  use "jose-elias-alvarez/null-ls.nvim"
  use "williamboman/nvim-lsp-installer"
  use "L3MON4D3/LuaSnip"
  use "rafamadriz/friendly-snippets"
  use "saadparwaiz1/cmp_luasnip"

  -- Navigation and search
  use	"kyazdani42/nvim-tree.lua"
  use	"kyazdani42/nvim-web-devicons"
  use	"nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-media-files.nvim"
  use "ahmedkhalf/project.nvim"
  use 'goolord/alpha-nvim'
  use "stevearc/aerial.nvim"

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

  -- Language plugins
  use "ray-x/go.nvim"
  use "dag/vim-fish"
  use "hashivim/vim-terraform"
  -- Colorschemes
  use "folke/tokyonight.nvim"
  use "LunarVim/onedarker.nvim"
  use "LunarVim/darkplus.nvim"
  use "LunarVim/colorschemes"
  use	"sainnhe/gruvbox-material"

  -- Plugin manager
  use "wbthomason/packer.nvim"

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
