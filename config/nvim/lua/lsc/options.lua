local o = vim.opt

o.backup = false
o.clipboard = "unnamedplus"
o.cmdheight = 2
o.completeopt = { "menuone", "noselect" }
o.conceallevel = 0
o.fileencoding = "utf-8"
o.hlsearch = true
o.ignorecase = true
o.mouse = "a"
o.pumheight = 10
o.showtabline = 2
o.smartcase = true
o.smartindent = true
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.swapfile = false
o.undofile = true
o.expandtab = true
o.cursorline = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.scrolloff = 8
o.wrap = false
o.shell = "fish"

vim.cmd [[ set iskeyword+=- ]]
