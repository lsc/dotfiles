local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

require "paq" {
	{"savq/paq-nvim", opt=true};
	 "Shougo/defx.nvim";
	 "airblade/vim-gitgutter";
	 "arcticicestudio/nord-vim";
	 "bronson/vim-trailing-whitespace";
	 "dag/vim-fish";
	 "dbeniamine/vim-mail";
	 "editorconfig/editorconfig-vim";
	 "fatih/vim-go";
	 "glepnir/lspsaga.nvim";
	 "hashivim/vim-terraform";
	 "itchyny/lightline.vim";
	 "jiangmiao/auto-pairs";
	 "jtratner/vim-flavored-markdown";
	 "junegunn/fzf";
	 "junegunn/fzf.vim";
	 "jvirtanen/vim-hcl";
	 "liuchengxu/vista.vim";
	 "marko-cerovac/material.nvim";
	 "neovim/nvim-lspconfig";
	 "norcalli/snippets.nvim";
	 "nvim-lua/completion-nvim";
	 "nvim-treesitter/nvim-treesitter";
	 "pearofducks/ansible-vim";
	 "steelsojka/completion-buffers";
	 "tpope/vim-fugitive";
	 "tpope/vim-markdown";
	 "tpope/vim-surround";
     "ms-jpq/coq_nvim";
}

require('settings')
require('lsp')
require('maps')
