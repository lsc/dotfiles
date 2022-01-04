-- Ensure Paq is installed and loaded.
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

-- Packages
require "paq" {
	"airblade/vim-gitgutter";
	"bronson/vim-trailing-whitespace";
	"dag/vim-fish";
	"editorconfig/editorconfig-vim";
	"hrsh7th/nvim-cmp";
	"jtratner/vim-flavored-markdown";
	"kyazdani42/nvim-tree.lua";
	"neovim/nvim-lspconfig";
	"nvim-lua/completion-nvim";
	"nvim-lua/plenary.nvim";
	"nvim-telescope/telescope.nvim";
	"nvim-treesitter/nvim-treesitter";
	"ryanoasis/vim-devicons";
	"sainnhe/gruvbox-material";
	{"savq/paq-nvim", opt=true};
}

-- Require plugin configs
require('lsc')
