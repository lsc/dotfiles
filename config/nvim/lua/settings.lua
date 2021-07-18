local o = vim.o
local wo = vim.wo
local bo = vim.bo

-- Global Options
o.swapfile = true
o.dir = '/tmp/'
o.smartcase = true
o.laststatus = 2
o.hlsearch = true
o.ignorecase = true
o.scrolloff = 12
o.showmode = false
o.mouse = 'a'
o.wildmenu = true
o.listchars='tab:│ ,nbsp:␣,trail:·,extends:>,precedes:<'
o.hidden = true
o.wildignore = [[
    .git,.hg,.svn
    *.aux,*.out,*.toc
    *.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
    *.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
    *.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
    *.mp3,*.oga,*.ogg,*.wav,*.flac
    *.eot,*.otf,*.ttf,*.woff
    *.doc,*.pdf,*.cbr,*.cbz
    *.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
    *.swp,.lock,.DS_Store,._*
]]
o.background = 'dark'
vim.cmd('syntax on')
vim.cmd('colorscheme nord')
vim.cmd("let g:lightline = { 'colorscheme': 'nord' }")

-- Window Options
wo.number = true
wo.wrap = false

-- Buffer Options
bo.expandtab = true
bo.filetype = 'on'
vim.cmd('filetype plugin indent on')
bo.tabstop = 4
bo.shiftwidth = 4
bo.softtabstop = 4
