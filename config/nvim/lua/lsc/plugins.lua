-- Ensure Packer is installed and loaded.
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path}
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
  use	"airblade/vim-gitgutter"
  use	"bronson/vim-trailing-whitespace"
  use	"dag/vim-fish"
  use	"editorconfig/editorconfig-vim"
  use	"hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "saadparwaiz1/cmp_luasnip"
  use	"jtratner/vim-flavored-markdown"
  use	"kyazdani42/nvim-tree.lua"
  use	"neovim/nvim-lspconfig"
  use	"nvim-lua/completion-nvim"
  use	"nvim-lua/plenary.nvim"
  use	"nvim-telescope/telescope.nvim"
  use	"nvim-treesitter/nvim-treesitter"
  use	"ryanoasis/vim-devicons"
  use	"sainnhe/gruvbox-material"
  use "nvim-lua/popup.nvim"
  use "wbthomason/packer.nvim"
  use "L3MON4D3/LuaSnip" -- Snipppets engine
  use "rafamadriz/friendly-snippets"
  -- Colorschemes
  use "folke/tokyonight.nvim"
  use "LunarVim/onedarker.nvim"
  use "LunarVim/darkplus.nvim"
  use "LunarVim/colorschemes"
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
