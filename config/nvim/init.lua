require('settings')
require('lsp')
require('maps')
require('material').set

vim.cmd 'packadd paq-nvim'
local paq = require'paq-nvim'.paq
paq{'savq/paq-nvim', opt=true}
paq 'Shougo/defx.nvim'
paq 'airblade/vim-gitgutter'
paq 'arcticicestudio/nord-vim'
paq 'bronson/vim-trailing-whitespace'
paq 'dag/vim-fish'
paq 'dbeniamine/vim-mail'
paq 'editorconfig/editorconfig-vim'
paq 'fatih/vim-go'
paq 'glepnir/lspsaga.nvim'
paq 'hashivim/vim-terraform'
paq 'itchyny/lightline.vim'
paq 'jiangmiao/auto-pairs'
paq 'jtratner/vim-flavored-markdown'
paq 'junegunn/fzf'
paq 'junegunn/fzf.vim'
paq 'jvirtanen/vim-hcl'
paq 'liuchengxu/vista.vim'
paq 'marko-cerovac/material.nvim'
paq 'neovim/nvim-lspconfig'
paq 'norcalli/snippets.nvim'
paq 'nvim-lua/completion-nvim'
paq 'nvim-treesitter/nvim-treesitter'
paq 'pearofducks/ansible-vim'
paq 'steelsojka/completion-buffers'
paq 'tpope/vim-fugitive'
paq 'tpope/vim-markdown'
paq 'tpope/vim-surround'
