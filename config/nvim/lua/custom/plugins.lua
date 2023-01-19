return function(use)
	-- Neo-tree
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				use_libuv_file_watcher = true,
				window = {
					mappings = {
						["o"] = "open_with_window_picker",
						["<cr>"] = "open_with_window_picker",
						["s"] = "vsplit_with_window_picker",
						["S"] = "split_with_window_picker",
					},
				},
			})
		end,
	})
	-- Aerial
	use({
		"stevearc/aerial.nvim",
		config = function()
			local telescope = require("telescope")
			telescope.load_extension("aerial")
			require("aerial").setup({})
		end,
	})
	-- Alpha
	use({
		"goolord/alpha-nvim",
		config = function()
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.header.val = {
				[[                               __                ]],
				[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
				[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
				[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
				[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
				[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
			}
			dashboard.section.buttons.val = {
				dashboard.button("f", "  Find file", require("telescope.builtin").find_files),
				dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
				-- dashboard.button("p", "  Find project", require'telescope'.extensions.projects.projects{}),
				dashboard.button("r", "  Recently used files", require("telescope.builtin").old_files),
				dashboard.button("t", "  Find text", require("telescope.builtin").live_grep),
				dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
				dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
			}
			dashboard.section.footer.opts.hl = "Type"
			dashboard.section.header.opts.hl = "Include"
			dashboard.section.buttons.opts.hl = "Keyword"
			-- dashboard.opts.opts.noautocmd = "true"

			require("alpha").setup(dashboard.opts)
		end,
	})
	-- Window picker
	-- Pick what buffer you want to open a file in interactively
	use({
		"s1n7ax/nvim-window-picker",
		tag = "v1.*",
		config = function()
			require("window-picker").setup({})
		end,
	})
	-- Autopairs
	-- Auto insert matching brackets, braces and similar characters
	use({
		"windwp/nvim-autopairs",
		config = function()
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
			require("nvim-autopairs").setup({})
		end,
	})
	-- Bufferline
	-- Show a nice a "tab bar" with buffers at the top of the editor
	use({
		"akinsho/bufferline.nvim",
		config = function()
			require("bufferline").setup({})
		end,
	})
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	})
	use({ "godlygeek/tabular" })
	use({
		"TimUntersberger/neogit",
		config = function()
			require("neogit").setup({})
		end,
	})
	use({
		"ahmedkhalf/project.nvim",
		config = function()
			require("telescope").load_extension("projects")
			require("project_nvim").setup({
				active = true,
				datapath = vim.fn.stdpath("data"),
				detection_methods = { "pattern", "lsp" },
				exclude_dirs = { "~/.dotfiles/*" },
				ignore_lsp = {},
				manual_mode = false,
				on_config_done = nil,
				patterns = {
					"go.mod",
					".git",
					"_darcs",
					".hg",
					".bzr",
					".svn",
					"Makefile",
					"package.json",
				},
				respect_buf_cwd = true,
				sync_root_with_cwd = true,
				update_focused_file = { enable = true, update_root = true },
				silent_chdir = true,
			})
		end,
	})
	use({
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				size = 35,
				open_mapping = [[<c-t>]],
				hide_numbers = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "vertical",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
					winblend = 0,
					highlights = { border = "Normal", background = "Normal" },
				},
			})
		end,
	})
	use({ "arcticicestudio/nord-vim" })
	use({ "rebelot/kanagawa.nvim" })
	use({ "rose-pine/neovim" })
	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			local diagnostics = null_ls.builtins.diagnostics
			local formatting = null_ls.builtins.formatting
			null_ls.setup({
				sources = {
					diagnostics.gitlint,
					diagnostics.golangci_lint,
					diagnostics.jsonlint,
					diagnostics.markdownlint,
					diagnostics.shellcheck,
					diagnostics.vale,
					diagnostics.yamllint,
					diagnostics.checkmake,
					diagnostics.eslint_d,
					formatting.beautysh,
					formatting.eslint_d,
					formatting.fish_indent,
					formatting.fixjson,
					formatting.gofumpt,
					formatting.lua_format,
					formatting.markdownlint,
					formatting.shellharden,
					formatting.stylua,
					formatting.terraform_fmt,
					formatting.yamlfmt,
				},
			})
		end,
	})
	use({ "dag/vim-fish" })
	use({
		"ray-x/go.nvim",
		requires = { "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("go").setup({})
		end,
	})
	use({
		"leoluz/nvim-dap-go",
		requires = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-go").setup({})
		end,
	})
	use({
		"nathom/filetype.nvim",
		config = function()
			require("filetype").setup({
				overrides = {
					extensions = {
						tf = "terraform",
						tfvars = "terraform",
						tfstate = "json",
					},
				},
			})
		end,
	})
	use({ "NoahTheDuke/vim-just" })
end
