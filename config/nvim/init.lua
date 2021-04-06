require('settings')
require('lsp')
require('maps')

vim.cmd 'packadd paq-nvim'
local paq = require'paq-nvim'.paq
paq{'savq/paq-nvim', opt=true}
paq 'neovim/nvim-lspconfig'
paq 'glepnir/lspsaga.nvim'
paq 'fatih/vim-go'
paq 'nvim-treesitter/nvim-treesitter'
paq 'nvim-lua/completion-nvim'
paq 'Shougo/defx.nvim'
paq 'liuchengxu/vista.vim'
paq 'itchyny/lightline.vim'
paq 'arcticicestudio/nord-vim'
paq 'jiangmiao/auto-pairs'
paq 'airblade/vim-gitgutter'
paq 'dbeniamine/vim-mail'
paq 'tpope/vim-surround'
paq 'editorconfig/editorconfig-vim'
paq 'steelsojka/completion-buffers'
paq 'norcalli/snippets.nvim'
paq 'pearofducks/ansible-vim'
paq 'jtratner/vim-flavored-markdown'
paq 'tpope/vim-markdown'
paq 'bronson/vim-trailing-whitespace'
paq 'jvirtanen/vim-hcl'
paq 'hashivim/vim-terraform'
paq 'tpope/vim-fugitive'
paq 'dag/vim-fish'
paq 'junegunn/fzf.vim'
paq 'junegunn/fzf'
