-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/lsc/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/lsc/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/lsc/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/lsc/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/lsc/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["aerial.nvim"] = {
    config = { "\27LJ\2\ni\0\0\4\0\5\0\r6\0\0\0'\2\1\0B\0\2\0029\1\2\0'\3\3\0B\1\2\0016\1\0\0'\3\3\0B\1\2\0029\1\4\0014\3\0\0B\1\2\1K\0\1\0\nsetup\vaerial\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/aerial.nvim",
    url = "https://github.com/stevearc/aerial.nvim"
  },
  ["alpha-nvim"] = {
    config = { "\27LJ\2\n„\a\0\0\b\0#\1I6\0\0\0'\2\1\0B\0\2\0029\1\2\0009\1\3\0015\2\5\0=\2\4\0019\1\2\0009\1\6\0014\2\a\0009\3\a\0'\5\b\0'\6\t\0'\a\n\0B\3\4\2>\3\1\0029\3\a\0'\5\v\0'\6\f\0'\a\r\0B\3\4\2>\3\2\0029\3\a\0'\5\14\0'\6\15\0'\a\16\0B\3\4\2>\3\3\0029\3\a\0'\5\17\0'\6\18\0'\a\19\0B\3\4\2>\3\4\0029\3\a\0'\5\20\0'\6\21\0'\a\22\0B\3\4\2>\3\5\0029\3\a\0'\5\23\0'\6\24\0'\a\25\0B\3\4\0?\3\0\0=\2\4\0019\1\2\0009\1\26\0019\1\27\1'\2\29\0=\2\28\0019\1\2\0009\1\3\0019\1\27\1'\2\30\0=\2\28\0019\1\2\0009\1\6\0019\1\27\1'\2\31\0=\2\28\0019\1\27\0009\1\27\1+\2\2\0=\2 \0016\1\0\0'\3!\0B\1\2\0029\1\"\0019\3\27\0B\1\2\1K\0\1\0\nsetup\nalpha\14noautocmd\fKeyword\fInclude\tType\ahl\topts\vfooter\f:qa<CR>\21Ôôô  Quit Neovim\6q$:e ~/.config/nvim/init.lua <CR>\23Óòï  Configuration\6c\30:Telescope live_grep <CR>\19ÔûÉ  Find text\6t\29:Telescope oldfiles <CR>\29Ôòà  Recently used files\6r :ene <BAR> startinsert <CR>\18ÔÖõ  New file\6e\31:Telescope find_files <CR>\19Ôúù  Find file\6f\vbutton\fbuttons\1\a\0\0006                               __                6  ___     ___    ___   __  __ /\\_\\    ___ ___    6 / _ `\\  / __`\\ / __`\\/\\ \\/\\ \\\\/\\ \\  / __` __`\\  6/\\ \\/\\ \\/\\  __//\\ \\_\\ \\ \\ \\_/ |\\ \\ \\/\\ \\/\\ \\/\\ \\ 6\\ \\_\\ \\_\\ \\____\\ \\____/\\ \\___/  \\ \\_\\ \\_\\ \\_\\ \\_\\6 \\/_/\\/_/\\/____/\\/___/  \\/__/    \\/_/\\/_/\\/_/\\/_/\bval\vheader\fsection\27alpha.themes.dashboard\frequire\rÄÄ¿ô\4\0" },
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  ["bufferline.nvim"] = {
    config = { "\27LJ\2\n<\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\15bufferline\frequire\0" },
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["fidget.nvim"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/fidget.nvim",
    url = "https://github.com/j-hui/fidget.nvim"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["neo-tree.nvim"] = {
    config = { "\27LJ\2\n—\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\vwindow\1\0\0\rmappings\1\0\0\1\0\4\t<cr>\28open_with_window_picker\6s\30vsplit_with_window_picker\6S\29split_with_window_picker\6o\28open_with_window_picker\nsetup\rneo-tree\frequire\0" },
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/neo-tree.nvim",
    url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  neogit = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vneogit\frequire\0" },
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/neogit",
    url = "https://github.com/TimUntersberger/neogit"
  },
  ["nord-vim"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/nord-vim",
    url = "https://github.com/arcticicestudio/nord-vim"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["null-ls.nvim"] = {
    config = { "\27LJ\2\n¯\2\0\0\v\0\21\0&6\0\0\0'\2\1\0B\0\2\0029\1\2\0009\1\3\0019\2\2\0009\2\4\0029\3\5\0005\5\19\0004\6\v\0009\a\6\1>\a\1\0069\a\a\1>\a\2\0069\a\b\1>\a\3\0069\a\t\1>\a\4\0069\a\n\1>\a\5\0069\a\v\1>\a\6\0069\a\f\1>\a\a\0069\a\t\2>\a\b\0069\a\r\0029\a\14\a5\t\16\0005\n\15\0=\n\17\tB\a\2\2>\a\t\0069\a\18\2>\a\n\6=\6\20\5B\3\2\1K\0\1\0\fsources\1\0\0\vstylua\15extra_args\1\0\0\1\4\0\0\14--no-semi\19--single-quote\23--jsx-single-quote\twith\rprettier\tvale\ryamllint\15shellcheck\17markdownlint\rjsonlint\18golangci_lint\fgitlint\nsetup\15formatting\16diagnostics\rbuiltins\fnull-ls\frequire\0" },
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n‹\1\0\0\n\0\f\0\0236\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\1\18\4\2\0009\2\4\2'\5\5\0009\6\6\0005\b\b\0005\t\a\0=\t\t\bB\6\2\0A\2\2\0016\2\0\0'\4\n\0B\2\2\0029\2\v\0024\4\0\0B\2\2\1K\0\1\0\nsetup\19nvim-autopairs\rmap_char\1\0\0\1\0\1\btex\5\20on_confirm_done\17confirm_done\aon\nevent\bcmp\"nvim-autopairs.completion.cmp\frequire\0" },
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["nvim-window-picker"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18window-picker\frequire\0" },
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/nvim-window-picker",
    url = "https://github.com/s1n7ax/nvim-window-picker"
  },
  ["onedark.nvim"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/onedark.nvim",
    url = "https://github.com/navarasu/onedark.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["project.nvim"] = {
    config = { "\27LJ\2\nØ\2\0\0\6\0\14\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\0024\3\0\0=\3\b\0026\3\t\0009\3\n\0039\3\v\3'\5\f\0B\3\2\2=\3\r\2B\0\2\1K\0\1\0\rdatapath\tdata\fstdpath\afn\bvim\15ignore_lsp\rpatterns\1\t\0\0\vgo.mod\t.git\v_darcs\b.hg\t.bzr\t.svn\rMakefile\17package.json\22detection_methods\1\3\0\0\blsp\fpattern\1\0\4\16show_hidden\1\vactive\2\17silent_chdir\2\16manual_mode\1\nsetup\17project_nvim\frequire\0" },
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/project.nvim",
    url = "https://github.com/ahmedkhalf/project.nvim"
  },
  tabular = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/tabular",
    url = "https://github.com/godlygeek/tabular"
  },
  ["telescope-fzf-native.nvim"] = {
    cond = { true },
    loaded = false,
    needs_bufread = false,
    only_cond = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/opt/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["toggleterm.nvim"] = {
    config = { "\27LJ\2\nˆ\2\0\0\5\0\f\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\0026\3\5\0009\3\6\0039\3\a\3=\3\a\0025\3\b\0005\4\t\0=\4\n\3=\3\v\2B\0\2\1K\0\1\0\15float_opts\15highlights\1\0\2\15background\vNormal\vborder\vNormal\1\0\2\rwinblend\3\0\vborder\vcurved\nshell\6o\bvim\20shade_filetypes\1\0\n\18close_on_exit\2\14direction\15horizontal\17persist_size\2\20insert_mappings\2\20start_in_insert\2\19shading_factor\3\2\20shade_terminals\2\17hide_numbers\2\17open_mapping\n<c-t>\tsize\3\20\nsetup\15toggleterm\frequire\0" },
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-rhubarb"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/vim-rhubarb",
    url = "https://github.com/tpope/vim-rhubarb"
  },
  ["vim-sleuth"] = {
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/vim-sleuth",
    url = "https://github.com/tpope/vim-sleuth"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/Users/lsc/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: toggleterm.nvim
time([[Config for toggleterm.nvim]], true)
try_loadstring("\27LJ\2\nˆ\2\0\0\5\0\f\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\0026\3\5\0009\3\6\0039\3\a\3=\3\a\0025\3\b\0005\4\t\0=\4\n\3=\3\v\2B\0\2\1K\0\1\0\15float_opts\15highlights\1\0\2\15background\vNormal\vborder\vNormal\1\0\2\rwinblend\3\0\vborder\vcurved\nshell\6o\bvim\20shade_filetypes\1\0\n\18close_on_exit\2\14direction\15horizontal\17persist_size\2\20insert_mappings\2\20start_in_insert\2\19shading_factor\3\2\20shade_terminals\2\17hide_numbers\2\17open_mapping\n<c-t>\tsize\3\20\nsetup\15toggleterm\frequire\0", "config", "toggleterm.nvim")
time([[Config for toggleterm.nvim]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\n‹\1\0\0\n\0\f\0\0236\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\1\18\4\2\0009\2\4\2'\5\5\0009\6\6\0005\b\b\0005\t\a\0=\t\t\bB\6\2\0A\2\2\0016\2\0\0'\4\n\0B\2\2\0029\2\v\0024\4\0\0B\2\2\1K\0\1\0\nsetup\19nvim-autopairs\rmap_char\1\0\0\1\0\1\btex\5\20on_confirm_done\17confirm_done\aon\nevent\bcmp\"nvim-autopairs.completion.cmp\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: alpha-nvim
time([[Config for alpha-nvim]], true)
try_loadstring("\27LJ\2\n„\a\0\0\b\0#\1I6\0\0\0'\2\1\0B\0\2\0029\1\2\0009\1\3\0015\2\5\0=\2\4\0019\1\2\0009\1\6\0014\2\a\0009\3\a\0'\5\b\0'\6\t\0'\a\n\0B\3\4\2>\3\1\0029\3\a\0'\5\v\0'\6\f\0'\a\r\0B\3\4\2>\3\2\0029\3\a\0'\5\14\0'\6\15\0'\a\16\0B\3\4\2>\3\3\0029\3\a\0'\5\17\0'\6\18\0'\a\19\0B\3\4\2>\3\4\0029\3\a\0'\5\20\0'\6\21\0'\a\22\0B\3\4\2>\3\5\0029\3\a\0'\5\23\0'\6\24\0'\a\25\0B\3\4\0?\3\0\0=\2\4\0019\1\2\0009\1\26\0019\1\27\1'\2\29\0=\2\28\0019\1\2\0009\1\3\0019\1\27\1'\2\30\0=\2\28\0019\1\2\0009\1\6\0019\1\27\1'\2\31\0=\2\28\0019\1\27\0009\1\27\1+\2\2\0=\2 \0016\1\0\0'\3!\0B\1\2\0029\1\"\0019\3\27\0B\1\2\1K\0\1\0\nsetup\nalpha\14noautocmd\fKeyword\fInclude\tType\ahl\topts\vfooter\f:qa<CR>\21Ôôô  Quit Neovim\6q$:e ~/.config/nvim/init.lua <CR>\23Óòï  Configuration\6c\30:Telescope live_grep <CR>\19ÔûÉ  Find text\6t\29:Telescope oldfiles <CR>\29Ôòà  Recently used files\6r :ene <BAR> startinsert <CR>\18ÔÖõ  New file\6e\31:Telescope find_files <CR>\19Ôúù  Find file\6f\vbutton\fbuttons\1\a\0\0006                               __                6  ___     ___    ___   __  __ /\\_\\    ___ ___    6 / _ `\\  / __`\\ / __`\\/\\ \\/\\ \\\\/\\ \\  / __` __`\\  6/\\ \\/\\ \\/\\  __//\\ \\_\\ \\ \\ \\_/ |\\ \\ \\/\\ \\/\\ \\/\\ \\ 6\\ \\_\\ \\_\\ \\____\\ \\____/\\ \\___/  \\ \\_\\ \\_\\ \\_\\ \\_\\6 \\/_/\\/_/\\/____/\\/___/  \\/__/    \\/_/\\/_/\\/_/\\/_/\bval\vheader\fsection\27alpha.themes.dashboard\frequire\rÄÄ¿ô\4\0", "config", "alpha-nvim")
time([[Config for alpha-nvim]], false)
-- Config for: bufferline.nvim
time([[Config for bufferline.nvim]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\15bufferline\frequire\0", "config", "bufferline.nvim")
time([[Config for bufferline.nvim]], false)
-- Config for: neo-tree.nvim
time([[Config for neo-tree.nvim]], true)
try_loadstring("\27LJ\2\n—\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\vwindow\1\0\0\rmappings\1\0\0\1\0\4\t<cr>\28open_with_window_picker\6s\30vsplit_with_window_picker\6S\29split_with_window_picker\6o\28open_with_window_picker\nsetup\rneo-tree\frequire\0", "config", "neo-tree.nvim")
time([[Config for neo-tree.nvim]], false)
-- Config for: project.nvim
time([[Config for project.nvim]], true)
try_loadstring("\27LJ\2\nØ\2\0\0\6\0\14\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\0024\3\0\0=\3\b\0026\3\t\0009\3\n\0039\3\v\3'\5\f\0B\3\2\2=\3\r\2B\0\2\1K\0\1\0\rdatapath\tdata\fstdpath\afn\bvim\15ignore_lsp\rpatterns\1\t\0\0\vgo.mod\t.git\v_darcs\b.hg\t.bzr\t.svn\rMakefile\17package.json\22detection_methods\1\3\0\0\blsp\fpattern\1\0\4\16show_hidden\1\vactive\2\17silent_chdir\2\16manual_mode\1\nsetup\17project_nvim\frequire\0", "config", "project.nvim")
time([[Config for project.nvim]], false)
-- Config for: neogit
time([[Config for neogit]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vneogit\frequire\0", "config", "neogit")
time([[Config for neogit]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: null-ls.nvim
time([[Config for null-ls.nvim]], true)
try_loadstring("\27LJ\2\n¯\2\0\0\v\0\21\0&6\0\0\0'\2\1\0B\0\2\0029\1\2\0009\1\3\0019\2\2\0009\2\4\0029\3\5\0005\5\19\0004\6\v\0009\a\6\1>\a\1\0069\a\a\1>\a\2\0069\a\b\1>\a\3\0069\a\t\1>\a\4\0069\a\n\1>\a\5\0069\a\v\1>\a\6\0069\a\f\1>\a\a\0069\a\t\2>\a\b\0069\a\r\0029\a\14\a5\t\16\0005\n\15\0=\n\17\tB\a\2\2>\a\t\0069\a\18\2>\a\n\6=\6\20\5B\3\2\1K\0\1\0\fsources\1\0\0\vstylua\15extra_args\1\0\0\1\4\0\0\14--no-semi\19--single-quote\23--jsx-single-quote\twith\rprettier\tvale\ryamllint\15shellcheck\17markdownlint\rjsonlint\18golangci_lint\fgitlint\nsetup\15formatting\16diagnostics\rbuiltins\fnull-ls\frequire\0", "config", "null-ls.nvim")
time([[Config for null-ls.nvim]], false)
-- Config for: nvim-window-picker
time([[Config for nvim-window-picker]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18window-picker\frequire\0", "config", "nvim-window-picker")
time([[Config for nvim-window-picker]], false)
-- Config for: aerial.nvim
time([[Config for aerial.nvim]], true)
try_loadstring("\27LJ\2\ni\0\0\4\0\5\0\r6\0\0\0'\2\1\0B\0\2\0029\1\2\0'\3\3\0B\1\2\0016\1\0\0'\3\3\0B\1\2\0029\1\4\0014\3\0\0B\1\2\1K\0\1\0\nsetup\vaerial\19load_extension\14telescope\frequire\0", "config", "aerial.nvim")
time([[Config for aerial.nvim]], false)
-- Conditional loads
time([[Conditional loading of telescope-fzf-native.nvim]], true)
  require("packer.load")({"telescope-fzf-native.nvim"}, {}, _G.packer_plugins)
time([[Conditional loading of telescope-fzf-native.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nvim-treesitter ]]
vim.cmd [[ packadd nvim-treesitter-textobjects ]]
time([[Sequenced loading]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
