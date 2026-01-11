local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	opts = {
		rocks = {
			enabled = true,
			root = vim.fn.stdpath("data") .. "/lazy-rocks",
			server = "https://nvim-neorocks.github.io/rocks-binaries/",
			hererocks = true,
		},
	},
	{
		"folke/neoconf.nvim",
		config = function()
			require("neoconf").setup({})
		end,
	},
	-- Theme
	{
		"f-person/auto-dark-mode.nvim",
		opts = {},
	},
	{
		"emanuel2718/vanta.nvim",
		priority = 1000,
		config = function()
			require("config.vanta")
			vim.cmd.colorscheme("vanta")
		end,
	},
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false,
		priority = 1000,
	},
	--QoL
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("config.nvim_web_devicons")
		end,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		dependencies = { "echasnovski/mini.icons" },
		---@type snacks.Config
		config = function()
			require("config.snacks")
		end,
	},
	-- mini.nvim
	{
		"echasnovski/mini.icons",
		version = "*",
		config = function()
			require("mini.icons").setup()
		end,
	},
	{
		"echasnovski/mini.statusline",
		version = "*",
		config = function()
			require("config.mini_statusline")
		end,
	},
	{
		"echasnovski/mini.cursorword",
		version = "*",
		config = function()
			require("mini.cursorword").setup()
		end,
	},
	-- {
	-- 	"echasnovski/mini.pairs",
	-- 	version = "*",
	-- 	config = function()
	-- 		require("config.mini_pairs")
	-- 	end,
	-- },
	{
		"echasnovski/mini.move",
		version = "*",
		config = function()
			require("config.mini_move")
		end,
	},
	{
		"echasnovski/mini.align",
		version = "*",
		config = function()
			require("mini.align").setup()
		end,
	},
	{
		"echasnovski/mini.surround",
		version = "*",
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		"echasnovski/mini.comment",
		version = "*",
		config = function()
			require("mini.comment").setup()
		end,
	},
	{
		"echasnovski/mini.trailspace",
		version = "*",
		config = function()
			require("mini.trailspace").setup()
		end,
	},
	{
		"echasnovski/mini.splitjoin",
		version = "*",
		config = function()
			require("config.mini_splitjoin")
		end,
	},
	{
		"echasnovski/mini.diff",
		version = "*",
		config = function()
			require("mini.diff").setup()
		end,
	},
	{
		"echasnovski/mini-git",
		version = "*",
		main = "mini.git",
		config = function()
			require("mini.git").setup()
		end,
	},
	---- Explorer
	{
		"stevearc/oil.nvim",
		-- dependencies = { "echasnovski/mini.icons", opts = {} },
		lazy = false,
		config = function()
			require("config.oil")
		end,
	},
	{
		"refractalize/oil-git-status.nvim",
		dependencies = {
			"stevearc/oil.nvim",
		},
		config = function()
			require("config.oil_git_status")
		end,
	},
	{
		"mikavilpas/yazi.nvim",
		version = "*", -- use the latest stable version
		event = "VeryLazy",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
		},
		---@type YaziConfig | {}
		opts = require("config.yazi"),
		init = function()
			vim.g.loaded_netrwPlugin = 1
		end,
	},
	---- Repo
	{
		"moyiz/git-dev.nvim",
		event = "VeryLazy",
		cmd = {
			"GitDevClean",
			"GitDevCleanAll",
			"GitDevCloseBuffers",
			"GitDevOpen",
			"GitDevRecents",
			"GitDevToggleUI",
			"GitDevXDGHandle",
		},
		config = function()
			require("config.git_dev")
		end,
	},
	---- Window
	{
		"sindrets/winshift.nvim",
		config = function()
			require("winshift").setup()
		end,
	},
	{
		"tadaa/vimade",
		config = function()
			require("vimade").setup({
				fadelevel = 0.8,
			})
		end,
	},
	{
		"b0o/incline.nvim",
		event = "VeryLazy",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
		},
		config = function()
			require("config.incline")
		end,
	},
	---- Session
	{
		"rmagatti/auto-session",
		lazy = false,
		config = function()
			require("config.auto_session")
		end,
		init = function()
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
		end,
	},
	{
		"natecraddock/workspaces.nvim",
		config = function()
			require("config.workspaces")
		end,
	},
	-- Synax
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		config = function()
			require("colorizer").setup()
		end,
	},
	---- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		dependencies = { "Hdoc1509/gh-actions.nvim" },
		config = function()
			require("gh-actions.tree-sitter").setup()
			require("config.treesitter")
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-context" },
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		config = function()
			require("config.ibl")
		end,
	},
	{
		"alexmozaidze/tree-comment.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		opts = require("config.tree_comment"),
	},
	-- LSP
	{
		"folke/lazydev.nvim",
		ft = "lua",
		dependencies = {
			{ "DrKJeff16/wezterm-types", lazy = true },
		},
		config = function()
			require("config.lazydev")
		end,
	},
	{ "neovim/nvim-lspconfig" },
	{
		"mason-org/mason.nvim",
		config = function()
			require("config.mason")
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("config.mason_lspconfig")
		end,
	},
	{
		"junnplus/lsp-setup.nvim",
		lazy = true,
		config = function()
			require("config.lsp_setup")
		end,
	},
	{ "mfussenegger/nvim-jdtls" },
	-- Linter
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("config.lint")
		end,
	},
	{
		"rshkarin/mason-nvim-lint",
		config = function()
			require("mason-nvim-lint").setup()
		end,
	},
	---- Formatter
	{
		"stevearc/conform.nvim",
		config = function()
			require("config.conform")
		end,
	},
	{
		"zapling/mason-conform.nvim",
		config = function()
			require("mason-conform").setup()
		end,
	},
	-- Markdown
	{
		"Nedra1998/nvim-mdlink",
		config = function()
			require("config.nvim_mdlink")
		end,
	},
	{
		"richardbizik/nvim-toc",
		config = function()
			require("nvim-toc").setup({
				toc_header = "Table of Contents",
			})
		end,
	},
	{
		"tttol/md-outline.nvim",
		config = function()
			require("md-outline").setup({
				auto_open = false,
			})
		end,
	},
	{
		"AntonVanAssche/md-headers.nvim",
		version = "*",
		ft = { "markdown" },
		config = function()
			require("config.md_headers")
		end,
	},
	-- CSV
	{
		"hat0uma/csvview.nvim",
		---@module "csvview"
		---@type CsvView.Options
		config = function()
			require("config.csvview")
		end,
		cmd = {
			"CsvViewEnable",
			"CsvViewDisable",
			"CsvViewToggle",
		},
	},
	-- typst
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
		config = function()
			require("typst-preview").setup()
		end,
	},
	-- LaTeX
	{
		"iurimateus/luasnip-latex-snippets.nvim",
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
			{ "lervag/vimtex", lazy = false },
		},
		config = function()
			require("luasnip-latex-snippets").setup() -- setup({ use_treesitter = true })
			require("luasnip").config.setup({ enable_autosnippets = false })
		end,
	},
	{
		"aidavdw/bibcite.nvim",
		cmd = {
			"CiteOpen",
			"CiteInsert",
			"CitePeek",
			"CiteNote",
		},
		config = function()
			require("config.bibcite")
		end,
	},
	-- CMP
	{
		"saghen/blink.cmp",
		event = { "BufReadPost", "BufNewFile" },
		version = "1.*",
		-- build = "cargo build --release",
		dependencies = {
			{ "xzbdmw/colorful-menu.nvim", opt = {} },
			{ "saghen/blink.compat" },
			{ "rafamadriz/friendly-snippets", version = "v2.*" },
			{ "erooke/blink-cmp-latex" },
			-- { "jdrupal-dev/css-vars.nvim" },
			-- { "alexandre-abrioux/blink-cmp-npm.nvim" },
			{ "yus-works/csc.nvim", opts = {} },
			{
				"Dynge/gitmoji.nvim",
				ft = "gitcommit",
				config = function()
					require("gitmoji").setup({})
				end,
			},
			{ "moyiz/blink-emoji.nvim" },
			{
				"Kaiser-Yang/blink-cmp-dictionary",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
			{ "ribru17/blink-cmp-spell" },
			{ "mikavilpas/blink-ripgrep.nvim" },
			{ "mgalliou/blink-cmp-tmux" },
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = require("config.blink"),
	},
	-- Snips
	{
		"L3MON4D3/LuaSnip",
		build = vim.fn.has("win32") ~= 0 and "make install_jsregexp" or nil,
		dependencies = {
			"rafamadriz/friendly-snippets",
			"benfowler/telescope-luasnip.nvim",
		},
		config = require("config.luasnip"),
	},
	-- Key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = { "echasnovski/mini.icons", opts = {} },
		config = function()
			require("config.which_key")
			require("config.keys.which_key")
		end,
	},
	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			require("config.hardtime")
		end,
	},
	{
		"timseriakov/spamguard.nvim",
		event = "VeryLazy",
		config = function()
			require("config.keys.spamguard")
		end,
		vim.schedule(function()
			require("spamguard").enable()
		end),
	},
	-- Edit
	---- Bookmark
	{
		"otavioschwanck/arrow.nvim",
		dependencies = {
			-- { "nvim-tree/nvim-web-devicons" },
			{ "echasnovski/mini.icons" },
		},
		opts = require("config.arrow"),
	},
	{
		"crusj/bookmarks.nvim",
		branch = "main",
		dependencies = { "nvim-web-devicons" },
		config = function()
			require("config.bookmarks").setup()
			require("telescope").load_extension("bookmarks")
		end,
		keys = require("config.keys.bookmarks"),
	},
	---- Buffer
	{
		"leath-dub/snipe.nvim",
		opts = {},
	},
	{
		"ahkohd/buffer-sticks.nvim",
		event = "VeryLazy",
		config = function()
			require("config.buffer_sticks")
		end,
		keys = require("config.keys.buffer_sticks"),
	},
	---- Convert
	{
		"necrom4/convy.nvim",
		cmd = { "Convy", "ConvySeparator" },
		opts = require("config.convy"),
	},
	---- Fold
	{
		"chrisgrieser/nvim-origami",
		event = "VeryLazy",
		dependencies = { "lewis6991/gitsigns.nvim" },
		config = function()
			require("config.origami")
		end,
		init = function()
			vim.opt.foldlevel = 99
			vim.opt.foldlevelstart = 99
		end,
	},
	---- Git
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("config.gitsigns")
		end,
	},
	---- Go
	{
		"abecodes/tabout.nvim",
		lazy = false,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		after = {
			"nvim-cmp",
			"blink.cmp",
		},
		config = function()
			require("tabout").setup({})
		end,
	},
	---- Goto
	{
		"rmagatti/goto-preview",
		event = "BufEnter",
		dependencies = {
			{
				"ibhagwan/fzf-lua",
				dependencies = { "nvim-mini/mini.icons" },
				---@module "fzf-lua"
				---@type fzf-lua.Config|{}
				---@diagnostics disable: missing-fields
				opts = {},
				---@diagnostics enable: missing-fields
			},
			{ "nvim-mini/mini.pick" },
			{ "rmagatti/logger.nvim" },
		},
		config = function()
			require("config.goto_preview")
		end,
	},
	{
		"dnlhc/glance.nvim",
		config = function()
			require("config.glance")
		end,
		cmd = "Glance",
	},
	---- Jump
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		config = function()
			require("flash")
		end,
		-- stylua: ignore
	},
	---- Mode
	{
		"TheBlob42/houdini.nvim",
		config = function()
			require("houdini").setup()
		end,
	},
	---- Multiple-cursor
	{
		"brenton-leighton/multiple-cursors.nvim",
		version = "*",
		config = function()
			require("config.multiple_cursors")
		end,
	},
	{
		"vodchella/hodur.nvim",
		config = function()
			require("config.keys.hodur")
		end,
	},
	---- Replace
	{
		"MagicDuck/grug-far.nvim",
		config = function()
			require("grug-far").setup()
		end,
	},
	---- Save
	{
		"Pocco81/auto-save.nvim",
		config = function()
			require("config.auto_save")
			if require("luasnip").in_snippet() then
				return false
			end
		end,
	},
	{
		"vladdoster/remember.nvim",
		config = function()
			require("remember").setup({
				open_folds = true,
			})
		end,
	},
	---- Sort
	{
		"sQVe/sort.nvim",
		config = function()
			require("config.sort")
		end,
	},
	{
		"mtrajano/tssorter.nvim",
		version = "*",
		---@module "tssorter"
		---@type TssorterOpts
		config = function()
			require("config.tssorter")
		end,
	},
	---- Undo
	{
		"y3owk1n/time-machine.nvim",
		config = function()
			require("time-machine").setup({})
		end,
		cmd = {
			"TimeMachineToggle",
			"TimeMachinePurgeBuffer",
			"TimeMachinePurgeAll",
			"TimeMachineLogShow",
			"TimeMachineLogClear",
		},
	},
	---- Visual
	{
		"rachartier/tiny-glimmer.nvim",
		event = "VeryLazy",
		priority = 10,
		config = function()
			require("tiny-glimmer").setup()
		end,
	},
	{
		"folke/twilight.nvim",
		config = function()
			require("config.twilight")
		end,
	},
	{
		"rewhile/fsread.nvim",
		config = function()
			require("config.fsread")
		end,
	},
	---- Other
	{
		"qwavies/smart-backspace.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
	},
	{
		"lewis6991/satellite.nvim",
		config = function()
			require("config.satellite")
		end,
	},
	{
		"saghen/filler-begone.nvim",
	},
	-- Search
	-- telescope.nvim
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.telescope")
		end,
	},
	---- Search file
	{ "MaximilianLloyd/adjacent.nvim" },
	---- Search file or folder
	{ "Verf/telescope-everything.nvim" },
	{ "princejoogie/dir-telescope.nvim" },
	---- Explorer
	{ "nvim-telescope/telescope-file-browser.nvim" },
	{
		"nvim-telescope/telescope-media-files.nvim",
		dependencies = {
			"nvim-lua/popup.nvim",
		},
	},
	---- Search history
	-- { "nvim-telescope/telescope-frecency.nvim" },
	{ "smartpde/telescope-recent-files" },
	{
		"jvgrootveld/telescope-zoxide",
		dependencies = {
			{ "nvim-lua/popup.nvim" },
		},
	},
	---- Search command
	{ "jonarrien/telescope-cmdline.nvim" },
	{ "nvim-telescope/telescope-dap.nvim" },
	---- Search command or cheatsheet
	{
		"sudormrfbin/cheatsheet.nvim",
		dependencies = {
			{ "nvim-lua/popup.nvim" },
		},
		config = function()
			require("config.cheatsheet")
		end,
	},
	{ "xiyaowong/telescope-emoji.nvim" },
	{
		"olacin/telescope-gitmoji.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").load_extension("gitmoji")
		end,
	},
	{ "ghassan0/telescope-glyph.nvim" },
	---- Search docset
	{
		"maskudo/devdocs.nvim",
		lazy = false,
		dependencies = {
			"folke/snacks.nvim",
		},
		cmd = { "DevDocs" },
		config = function()
			require("config.devdocs")
		end,
	},
	---- Search Tips
	{
		"saxon1964/neovim-tips",
		version = "*",
		dependencies = {
			"MunifTanjim/nui.nvim",
			--"MeanderingProgrammer/render-markdown.nvim",
		},
		config = function()
			require("config.neovim_tips")
		end,
	},
	---- Project
	{
		"coffebar/neovim-project",
		dependencies = {
			{ "Shatur/neovim-session-manager" },
		},
		lazy = false,
		priority = 100,
		init = function()
			vim.opt.sessionoptions:append("globals")
		end,
		config = function()
			require("config.neovim_project")
		end,
	},
	{ "piersolenski/telescope-import.nvim" },
	---- Other
	{ "tsakirist/telescope-lazy.nvim" },
	{ "polirritmico/telescope-lazy-plugins.nvim" },
	{
		"ryanmsnyder/toggleterm-manager.nvim",
		dependencies = {
			"akinsho/nvim-toggleterm.lua",
		},
	},
	{
		"debugloop/telescope-undo.nvim",
	},
	{
		"AckslD/nvim-neoclip.lua",
		dependencies = {
			{ "kkharji/sqlite.lua", module = "sqlite" },
		},
		config = function()
			require("config.neoclip")
		end,
		opts = { keys = require("config.keys.neoclip") },
	},
	{ "crispgm/telescope-heading.nvim" },
	{ "nvim-telescope/telescope-bibtex.nvim" },
	-- Run
	---- Console
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("config.toggleterm")
			require("config.keys.toggleterm")
		end,
	},
	---- Debug
	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
	},
	---- DAP
	{
		"mfussenegger/nvim-dap",
		-- dependencies = { "jbyuki/one-small-step-for-vimkind" },
		lazy = VaryLazy,
		config = function()
			require("config.dap")
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("config.dapui")
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		cond = vim.fn.has("unix") == 1,
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
		ft = { "python" },
		config = function()
			local python_path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(python_path)
		end,
	},
	-- Develop
	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			require("config.opencode")
			require("config.keys.opencode")
		end,
	},
	{
		"S1M0N38/love2d.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"Mathijs-Bakker/godotdev.nvim",
		dependencies = {
			"nvim-lspconfig",
			"nvim-dap",
			"nvim-dap-ui",
			"nvim-treesitter",
		},
	},
	-- Other
	{
		"DanielPonte01/ink.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("config.ink")
		end,
	},
	-- {
	-- 	"helmecke/epubedit.nvim",
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 	},
	-- 	config = function()
	-- 		require("config.epubedit").setup()
	-- 	end,
	-- },
	{
		"Nealium/dict-popup.nvim",
		cond = vim.fn.has("unix") == 1,
		opts = require("config.dict_popup"),
	},
	{
		"neo451/feed.nvim",
		dependencies = { "folke/snacks.nvim", priority = 1000, lazy = false },
		cmd = "Feed",
		---@module 'feed'
		---@type feed.config
		config = function()
			require("config.feed")
		end,
	},
	{
		"uga-rosa/translate.nvim",
		cond = vim.fn.has("unix") == 1,
		config = function()
			require("config.translate")
		end,
	},
	{
		"echuraev/translate-shell.vim",
		cond = vim.fn.has("unix") == 1,
	},
	{
		"christoomey/vim-tmux-navigator",
		cond = vim.fn.has("unix") == 1,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
})
