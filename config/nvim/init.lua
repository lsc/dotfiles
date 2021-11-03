local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

require "paq" {
	"Shougo/defx.nvim";
	"airblade/vim-gitgutter";
	"arcticicestudio/nord-vim";
	"bronson/vim-trailing-whitespace";
	"dag/vim-fish";
	"dbeniamine/vim-mail";
	"editorconfig/editorconfig-vim";
	"glepnir/lspsaga.nvim";
	"hashivim/vim-terraform";
	"itchyny/lightline.vim";
	"jiangmiao/auto-pairs";
	"jtratner/vim-flavored-markdown";
	"jvirtanen/vim-hcl";
	"liuchengxu/vista.vim";
	"marko-cerovac/material.nvim";
	"neovim/nvim-lspconfig";
	"nvim-lua/completion-nvim";
	"nvim-lua/plenary.nvim";
	"nvim-telescope/telescope.nvim";
	"nvim-treesitter/nvim-treesitter";
	"ryanoasis/vim-devicons";
	"tpope/vim-fugitive";
	"tpope/vim-markdown";
	"tpope/vim-surround";
	"hrsh7th/nvim-cmp";
	"hrsh7th/vim-vsnip";
	"hrsh7th/cmp-buffer";
	"pwntester/octo.nvim";
	{"savq/paq-nvim", opt=true};
}

require('settings')
require('lsp')
require('maps')
