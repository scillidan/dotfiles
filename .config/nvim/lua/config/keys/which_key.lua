local wk = require("which-key")

wk.add({
	-- Switch Light/Dark theme
	{
		"<leader>sc",
		function()
			if vim.g.current_theme == "vanta" then
				vim.cmd("colorscheme github_light_colorblind")
				vim.g.current_theme = "github_light_colorblind"
			else
				vim.cmd("colorscheme vanta")
				vim.g.current_theme = "vanta"
			end
		end,
		desc = "Toggle theme",
		mode = "n",
	},
	-- apidocs.nvim
	{ "<leader>sad", "<cmd>ApidocsOpen<cr>", desc = "Search Api Doc" },
	-- auto-session
	{ "<leader>wr", "<Cmd>AutoSession search<CR>", desc = "AutoSession search" },
	{ "<leader>ws", "<Cmd>AutoSession save<CR>", desc = "AutoSession save" },
	{ "<leader>wa", "<Cmd>AutoSession toggle<CR>", desc = "AutoSession toggle" },
	{ "<leader>wd", "<Cmd>AutoSession delete<CR>", desc = "AutoSession delete" },
	-- bibcite.nvim
	{ "<leader>ci", "<Cmd>CiteInsert<CR>", desc = "CiteInsert" },
	{ "<leader>cp", "<Cmd>CitePeek<CR>", desc = "CitePeek" },
	{ "<leader>co", "<Cmd>CiteOpen<CR>", desc = "CiteOpen" },
	{ "<leader>cn", "<Cmd>CiteNote<CR>", desc = "CiteNote" },
	-- devdocs.nvim
	{ "<leader>hg", "<Cmd>DevDocs get<CR>", desc = "DevDocs get", mode = "n" },
	{ "<leader>hi", "<Cmd>DevDocs install<CR>", desc = "DevDocs install", mode = "n" },
	{
		"<leader>hv",
		function()
			local devdocs = require("devdocs")
			local installedDocs = devdocs.GetInstalledDocs()
			vim.ui.select(installedDocs, {}, function(selected)
				if not selected then
					return
				end
				local docDir = devdocs.GetDocDir(selected)
				-- prettify the filename as you wish
				Snacks.picker.files({ cwd = docDir })
			end)
		end,
		desc = "Devdocs by snacks",
		mode = "n",
	},
	{ "<leader>hd", "<Cmd>DevDocs delete<CR>", desc = "DevDocs delete", mode = "n" },
	-- flash.nvim
	{
		"<leader>s",
		function()
			require("flash").jump()
		end,
		desc = "flash",
		mode = { "n", "x", "o" },
	},
	{
		"<leader>S",
		function()
			require("flash").treesitter()
		end,
		desc = "flash treesitter",
		mode = { "n", "x", "o" },
	},
	{
		"<leader>r",
		function()
			require("flash").remote()
		end,
		desc = "flash remote",
		mode = "o",
	},
	{
		"<leader>R",
		function()
			require("flash").treesitter_search()
		end,
		desc = "flash treesitter_search",
		mode = { "o", "x" },
	},
	{
		"<C-s>",
		function()
			require("flash").toggle()
		end,
		desc = "Toggle Flash Search",
		mode = { "c" },
	},
	-- git-dev.nvim
	{
		"<leader>go",
		function()
			local repo = vim.fn.input("Repository name / URI: ")
			if repo ~= "" then
				require("git-dev").open(repo)
			end
		end,
		desc = "[O]pen a remote git repository",
	},
	-- glance.nvim
	{ "gR", "<Cmd>Glance references<CR>", desc = "Glance references<CR>", mode = "n" },
	{ "gD", "<Cmd>Glance definitions<CR>", desc = "Glance definitions<CR>", mode = "n" },
	{ "gY", "<Cmd>Glance type_definitions<CR>", desc = "Glance type_definitions<CR>", mode = "n" },
	{ "gM", "<Cmd>Glance implementations<CR>", desc = "Glance implementations<CR>", mode = "n" },
	-- grug-far.nvim
	{
		"<leader>gf",
		'<Cmd>lua require("grug-far").open({ engine = "astgrep" })<CR>',
		desc = "grug-far.open",
		mode = "n",
	},
	-- love2d.nvim
	{ "<leader>vv", "<Cmd>LoveRun<CR>", desc = "LoveRun" },
	{ "<leader>vs", "<Cmd>LoveStop<CR>", desc = "LoveStop" },
	-- luasnip
	--  { "<C-k>", '<Cmd>lua require("luasnip").expand()<CR>', desc = "luasnip expand", mode = { "i", "s" } },
	--  { "<C-h>", '<Cmd>lua require("luasnip").jump(-1)<CR>', desc = "luasnip jump(-1)", mode = { "i", "s" } },
	--  { "<C-l>", '<Cmd>lua require("luasnip").jump(1)<CR>', desc = "luasnip jump(1)", mode = { "i", "s" } },
	-- md-headers
	{ "<leader>mh", "<Cmd>MDHeadersCurrent<CR>", desc = "MDHeadersCurrent", mode = "n" },
	-- multiple-cursors.nvim
	{
		"<S-Down>",
		"<Cmd>MultipleCursorsAddDown<CR>",
		mode = { "n", "i", "x" },
		desc = "MultipleCursorsAddDown",
	},
	{ "<S-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i", "x" }, desc = "MultipleCursorsAddUp" },
	{
		"<C-LeftMouse>",
		"<Cmd>MultipleCursorsMouseAddDelete<CR>",
		mode = { "n", "i" },
		desc = "MultipleCursorsMouseAddDelete",
	},
	{
		"<Leader>a",
		"<Cmd>MultipleCursorsAddMatches<CR>",
		mode = { "n", "x" },
		desc = "MultipleCursorsAddMatches",
	},
	-- nvim-jdtls
	{ "<A-o>", "<Cmd>lua require'jdtls'.organize_imports()<CR>", desc = "organize_imports", mode = "n" },
	{ "crv", "<Cmd>lua require('jdtls').extract_variable()<CR>", desc = "extract_variable", mode = "n" },
	{ "crv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", desc = "extract_variable(true)", mode = "v" },
	{ "crc", "<Cmd>lua require('jdtls').extract_constant()<CR>", desc = "extract_constant", mode = "n" },
	{ "crc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", desc = "extract_constant(true)", mode = "v" },
	{ "crm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", desc = "extract_method(true)", mode = "v" },
	{ "<leader>df", "<Cmd>lua require'jdtls'.test_class()<CR>", desc = "test_class()", mode = "n" },
	{ "<leader>dn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", desc = "test_nearest_method()", mode = "n" },
	-- neovim-tips
	{ "<leader>nto", "<Cmd>NeovimTips<CR>", desc = "NeovimTips", mode = "n" },
	{ "<leader>nte", "<Cmd>NeovimTipsEdit<CR>", desc = "NeovimTipsEdit", mode = "n" },
	{ "<leader>nta", "<Cmd>NeovimTipsAdd<CR>", desc = "NeovimTipsEditAdd", mode = "n" },
	{ "<leader>ntr", "<Cmd>NeovimTipsRandom<CR>", desc = "NeovimTipsRandom", mode = "n" },
	-- oil.nvim
	{ "-", "<Cmd>Oil<CR>", desc = "Oil", mode = "n" },
	-- snipe.nvim
	{ "<leader>gb", '<Cmd>lua require("snipe").open_buffer_menu()<CR>', desc = "Open Snipe buffer menu", mode = "n" },
	-- sort.nvim
	{ "go", "<Cmd>Sort<CR>", desc = "<Cmd>Sort", mode = "n" },
	{ "go", "<Esc><Cmd>Sort<CR>", desc = "<Esc><Cmd>Sort", mode = "v" },
	{ 'go"', 'vi"<Esc><Cmd>Sort<CR>', desc = 'vi"<Esc><Cmd>Sort', mode = "n" },
	{ "go'", "vi'<Esc><Cmd>Sort<CR>", desc = "vi'<Esc><Cmd>Sort", mode = "n" },
	{ "go(", "vi(<Esc><Cmd>Sort<CR>", desc = "vi(<Esc><Cmd>Sort", mode = "n" },
	{ "go[", "vi[<Esc><Cmd>Sort<CR>", desc = "vi[<Esc><Cmd>Sort", mode = "n" },
	{ "gop", "vip<Esc><Cmd>Sort<CR>", desc = "vip<Esc><Cmd>Sort", mode = "n" },
	{ "go{", "vi{<Esc><Cmd>Sort<CR>", desc = "vi{<Esc><Cmd>Sort", mode = "n" },
	-- time-machine.nvim
	{
		"<local eader>tm",
		"<Cmd>TimeMachineToggle<CR>",
		desc = "TimeMachineToggle",
	},
	{
		"<leader>tmx",
		"<Cmd>TimeMachinePurgeBuffer<CR>",
		desc = "TimeMachinePurgeBuffer",
	},
	{
		"<leader>tmX",
		"<Cmd>TimeMachinePurgeAll<CR>",
		desc = "TimeMachinePurgeAll",
	},
	{
		"<leader>tml",
		"<Cmd>TimeMachineLogShow<CR>",
		desc = "TimeMachineLogShow",
	},
	-- translate.nvim
	{ "<leader>zh", "viw:Translate ZH<CR>", desc = "viw:Translate ZH", mode = { "n", "o" } },
	{ "<leader>zh", "<Cmd>Translate ZH<CR>", desc = "Translate ZH", mode = "v" },
	-- translate-shell.vim
	-- { "<leader>tr", "<Esc>:Trans<CR>", desc = "Trans", mode = "i" },
	{ "<leader>tr", "<Cmd>Trans<CR>", desc = "Trans", mode = { "n", "v" } },
	{ "<leader>td", "<Cmd>TransSelectDirection<CR>", desc = "TransSelectDirection", mode = { "n", "v" } },
	-- trouble.nvim
	{
		"<leader>xx",
		"<Cmd>Trouble diagnostics toggle<CR>",
		desc = "Trouble diagnostics toggle",
	},
	{
		"<leader>xX",
		"<Cmd>Trouble diagnostics toggle filter.buf=0<CR>",
		desc = "Trouble diagnostics toggle filter.buf=0",
	},
	{
		"<leader>cs",
		"<Cmd>Trouble symbols toggle focus=false<CR>",
		desc = "Trouble symbols toggle",
	},
	{
		"<leader>cl",
		"<Cmd>Trouble lsp toggle focus=false win.position=right<CR>",
		desc = "Trouble lsp toggle",
	},
	{
		"<leader>xL",
		"<Cmd>Trouble loclist toggle<CR>",
		desc = "Trouble loclist toggle",
	},
	{
		"<leader>xQ",
		"<Cmd>Trouble qflist toggle<CR>",
		desc = "Trouble qflist toggle",
	},
	-- tssorter.nvim
	{ "<leader>ts", "<Cmd>TSSort list<CR>", desc = "TSSort list", mode = "n" },
	{ "<leader>ts", "<Esc><Cmd>TSSort list<CR>", desc = "TSSort list", mode = "v" },
	-- which-key.nvim
	{
		"<leader>!",
		'<Cmd>lua require("which-key").show({ global = false })<CR>',
		desc = "which-key.show",
		mode = "n",
	},
	-- winshift.nvim
	{
		{ "<C-W><C-M>", "<Cmd>WinShift<CR>", desc = "WinShift" },
		{ "<C-W>m", "<Cmd>WinShift<CR>", desc = "WinShift" },
		{ "<C-W>X", "<Cmd>WinShift swap<CR>", desc = "WinShift swap" },
		{ "<C-M-H>", "<Cmd>WinShift left<CR>", desc = "WinShift left" },
		{ "<C-M-J>", "<Cmd>WinShift down<CR>", desc = "WinShift down" },
		{ "<C-M-K>", "<Cmd>WinShift up<CR>", desc = "WinShift up" },
		{ "<C-M-L>", "<Cmd>WinShift right<CR>", desc = "WinShift right" },
	},
	-- yazi.nvim
	{ "<leader>-", "<Cmd>Yazi<CR>", desc = "Open yazi at the current file", mode = { "n", "v" } },
	{ "<leader>cw", "<Cmd>Yazi cwd<CR>", desc = "Open the file manager in nvim's working directory" },
	{ "<C-up>", "<Cmd>Yazi toggle<CR>", desc = "Resume the last yazi session" },
	-- telescope.nvim
	-- nvim-telescope/telescope.nvim
	{ "<leader>kk", "<Cmd>Telescope keymaps<CR>", desc = "Telescope keymaps", mode = "n" },
	{ "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Telescope find_files", mode = "n" },
	{ "<leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Telescope live_grep", mode = "n" },
	{ "<leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Telescope buffers", mode = "n" },
	{ "<leader>ht", "<Cmd>Telescope help_tags<CR>", desc = "Telescope help_tags", mode = "n" },
	-- MaximilianLloyd/adjacent.nvim
	{ "<leader>fa", "<Cmd>Telescope adjacent<CR>", desc = "Telescope adjacent", mode = "n" },
	-- princejoogie/dir-telescope.nvim
	{ "<leader>dfg", "<Cmd>Telescope dir live_grep<CR>", desc = "Telescope dir live_grep", mode = "n" },
	{ "<leader>dff", "<Cmd>Telescope dir find_files<CR>", desc = "Telescope dir find_files", mode = "n" },
	-- Verf/telescope-everything.nvim
	{ "<leader>es", "<Cmd>Telescope everything<CR>", desc = "Telescope everything", mode = "n" },
	-- nvim-telescope/telescope-file-browser.nvim
	{ "<leader>br", "<Cmd>Telescope file_browser<CR>", desc = "Telescope file_browser", mode = "n" },
	-- nvim-telescope/telescope-media-files.nvim
	{ "<leader>mf", "<Cmd>Telescope media_files<CR>", desc = "Telescope media_files", mode = "n" },
	-- smartpde/telescope-recent-files
	{
		"<leader>R",
		"<Cmd>lua require('telescope').extensions.recent_files.pick()<CR>",
		desc = "Telescope recent_files",
		mode = "n",
	},
	-- nvim-telescope/telescope-frecency.nvim
	-- { "<leader>R", "<Cmd>Telescope frecency<CR>", desc = "Telescope frecency", mode = "n" },
	-- jvgrootveld/telescope-zoxide
	{ "<leader>zi", "<Cmd>Telescope zoxide list<CR>", desc = "Telescope zoxide list", mode = "n" },
	-- jonarrien/telescope-cmdline.nvim
	{ "Q", "<Cmd>Telescope cmdline<CR>", desc = "Telescope cmdline", mode = "n" },
	-- nvim-telescope/telescope-dap.nvim
	-- alduraibi/telescope-glyph.nvim
	{ "<leader>gyp", "<Cmd>Telescope glyph<CR>", desc = "Telescope glyph", mode = "n" },
	-- xiyaowong/telescope-emoji.nvim
	{ "<leader>emj", "<Cmd>Telescope emoji<CR>", desc = "Telescope emoji", mode = "n" },
	-- olacin/telescope-gitmoji.nvim
	{ "<leader>gmj", "<Cmd>Telescope gitmoji<CR>", desc = "Telescope gitmoji", mode = "n" },
	-- coffebar/neovim-project
	{ "<leader>pr", "<Cmd>NeovimProjectLoadRecent<CR>", desc = "NeovimProjectLoadRecent", mode = "n" },
	{
		"<leader>pj",
		"<Cmd>Telescope neovim-project discover<CR>",
		desc = "Telescope neovim-project discover",
		mode = "n",
	},
	{
		"<leader>ph",
		"<Cmd>Telescope neovim-project history<CR>",
		desc = "Telescope neovim-project history",
		mode = "n",
	},
	-- piersolenski/telescope-import.nvim
	{ "<leader>imp", "<Cmd>Telescope import<CR>", desc = "Telescope import", mode = "n" },
	-- tsakirist/telescope-lazy.nvim
	{ "<leader>lzy", "<Cmd>Telescope lazy<CR>", desc = "Telescope lazy", mode = "n" },
	-- polirritmico/telescope-lazy-plugins.nvim
	{ "<leader>lzp", "<Cmd>Telescope lazy_plugins<CR>", desc = "Telescope lazy_plugins", mode = "n" },
	-- ryanmsnyder/toggleterm-manager.nvim
	{ "<leader>trm", "<Cmd>Telescope toggleterm_manager<CR>", desc = "Telescope toggleterm_manager", mode = "n" },
	-- debugloop/telescope-undo.nvim
	{ "<leader>und", "<Cmd>Telescope undo<CR>", desc = "Telescope undo" },
	-- AckslD/nvim-neoclip.lua
	{ "<leader>clp", "<Cmd>Telescope neoclip<CR>", desc = "Telescope neoclip" },
	-- nvim-telescope/telescope-bibtex.nvim
	{ "<leader>bib", "<Cmd>Telescope bibtex<CR>", desc = "Telescope bibtex" },
})
