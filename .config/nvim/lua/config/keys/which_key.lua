local wk = require("which-key")
wk.add({
	--auto-session
	{ "<leader>wr", "<cmd>SessionSearch<CR>", desc = "SessionSearch" },
	{ "<leader>ws", "<cmd>SessionSave<CR>", desc = "SessionSave" },
	{ "<leader>wa", "<cmd>SessionToggleAutoSave<CR>", desc = "SessionToggleAutoSave" },
	--bibcite.nvim
	{ "<leader>ci", "<cmd>CiteInsert<CR>", desc = "CiteInsert" },
	{ "<leader>cp", "<cmd>CitePeek<CR>", desc = "CitePeek" },
	{ "<leader>co", "<cmd>CiteOpen<CR>", desc = "CiteOpen" },
	{ "<leader>cn", "<cmd>CiteNote<CR>", desc = "CiteNote" },
	--devdocs.nvim
	{ "<leader>hg", "<cmd>DevDocs get<cr>", desc = "DevDocs get", mode = "n" },
	{ "<leader>hi", "<cmd>DevDocs install<cr>", desc = "DevDocs install", mode = "n" },
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
				--prettify the filename as you wish
				Snacks.picker.files({ cwd = docDir })
			end)
		end,
		desc = "Devdocs by snacks",
		mode = "n",
	},
	{ "<leader>hd", "<cmd>DevDocs delete<cr>", desc = "DevDocs delete", mode = "n" },
	--flash.nvim
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
	--git-dev.nvim
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
	--glance.nvim
	{ "gR", "<cmd>Glance references<cr>", desc = "Glance references<cr>", mode = "n" },
	{ "gD", "<cmd>Glance definitions<cr>", desc = "Glance definitions<cr>", mode = "n" },
	{ "gY", "<cmd>Glance type_definitions<cr>", desc = "Glance type_definitions<cr>", mode = "n" },
	{ "gM", "<cmd>Glance implementations<cr>", desc = "Glance implementations<cr>", mode = "n" },
	--grug-far.nvim
	{
		"<Leader>gf",
		'<CMD>lua require("grug-far").open({ engine = "astgrep" })<CR>',
		desc = "grug-far.open",
		mode = "n",
	},
	--love2d.nvim
	{ "<leader>vv", "<cmd>LoveRun<cr>", desc = "LoveRun" },
	{ "<leader>vs", "<cmd>LoveStop<cr>", desc = "LoveStop" },
	--md-headers
	{ "<leader>mh", "<cmd>MDHeadersCurrent<cr>", desc = "MDHeadersCurrent", mode = "n" },
	--multiple-cursors.nvim
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
	--oil.nvim
	{ "-", "<cmd>Oil<cr>", desc = "Oil", mode = "n" },
	--sort.nvim
	{ "go", "<Cmd>Sort<CR>", desc = "<Cmd>Sort", mode = "n" },
	{ "go", "<Esc><Cmd>Sort<CR>", desc = "<Esc><Cmd>Sort", mode = "v" },
	{ 'go"', 'vi"<Esc><Cmd>Sort<CR>', desc = 'vi"<Esc><Cmd>Sort', mode = "n" },
	{ "go'", "vi'<Esc><Cmd>Sort<CR>", desc = "vi'<Esc><Cmd>Sort", mode = "n" },
	{ "go(", "vi(<Esc><Cmd>Sort<CR>", desc = "vi(<Esc><Cmd>Sort", mode = "n" },
	{ "go[", "vi[<Esc><Cmd>Sort<CR>", desc = "vi[<Esc><Cmd>Sort", mode = "n" },
	{ "gop", "vip<Esc><Cmd>Sort<CR>", desc = "vip<Esc><Cmd>Sort", mode = "n" },
	{ "go{", "vi{<Esc><Cmd>Sort<CR>", desc = "vi{<Esc><Cmd>Sort", mode = "n" },
	--time-machine.nvim
	{
		"<leader>tm",
		"<cmd>TimeMachineToggle<cr>",
		desc = "TimeMachineToggle",
	},
	{
		"<leader>tmx",
		"<cmd>TimeMachinePurgeBuffer<cr>",
		desc = "TimeMachinePurgeBuffer",
	},
	{
		"<leader>tmX",
		"<cmd>TimeMachinePurgeAll<cr>",
		desc = "TimeMachinePurgeAll",
	},
	{
		"<leader>tml",
		"<cmd>TimeMachineLogShow<cr>",
		desc = "TimeMachineLogShow",
	},
	--translate.nvim
	{ "<leader>zh", "viw:Translate ZH<cr>", desc = "viw:Translate ZH", mode = { "n", "o" } },
	{ "<leader>zh", "<cmd>Translate ZH<cr>", desc = "Translate ZH", mode = "v" },
	--translate-shell.vim
	{ "<leader>t", "<esc>:Trans<cr>", desc = "Trans", mode = "i" },
	{ "<leader>t", "<cmd>Trans<cr>", desc = "Trans", mode = { "n", "v" } },
	{ "<leader>td", "<cmd>TransSelectDirection<cr>", desc = "TransSelectDirection", mode = { "n", "v" } },
	--trouble.nvim
	{
		"<leader>xx",
		"<cmd>Trouble diagnostics toggle<cr>",
		desc = "Trouble diagnostics toggle",
	},
	{
		"<leader>xX",
		"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
		desc = "Trouble diagnostics toggle filter.buf=0",
	},
	{
		"<leader>cs",
		"<cmd>Trouble symbols toggle focus=false<cr>",
		desc = "Trouble symbols toggle",
	},
	{
		"<leader>cl",
		"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
		desc = "Trouble lsp toggle",
	},
	{
		"<leader>xL",
		"<cmd>Trouble loclist toggle<cr>",
		desc = "Trouble loclist toggle",
	},
	{
		"<leader>xQ",
		"<cmd>Trouble qflist toggle<cr>",
		desc = "Trouble qflist toggle",
	},
	--tssorter.nvim
	{ "<leader>ts", "<cmd>TSSort list<cr>", desc = "TSSort list", mode = "n" },
	{ "<leader>ts", "<esc><cmd>TSSort list<cr>", desc = "TSSort list", mode = "v" },
	--which-key.nvim
	{
		"<leader>!",
		'<cmd>lua require("which-key").show({ global = false })<CR>',
		desc = "which-key.show",
		mode = "n",
	},
	--winshift.nvim
	{
		{ "<C-W><C-M>", "<cmd>WinShift<cr>", desc = "WinShift" },
		{ "<C-W>m", "<cmd>WinShift<cr>", desc = "WinShift" },
		{ "<C-W>X", "<cmd>WinShift swap<cr>", desc = "WinShift swap" },
		{ "<C-M-H>", "<cmd>WinShift left<cr>", desc = "WinShift left" },
		{ "<C-M-J>", "<cmd>WinShift down<cr>", desc = "WinShift down" },
		{ "<C-M-K>", "<cmd>WinShift up<cr>", desc = "WinShift up" },
		{ "<C-M-L>", "<cmd>WinShift right<cr>", desc = "WinShift right" },
	},
	----telescope.nvim
	--nvim-telescope/telescope.nvim
	{ "<leader>kk", "<cmd>Telescope keymaps<cr>", desc = "Telescope keymaps", mode = "n" },
	{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Telescope find_files", mode = "n" },
	{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Telescope live_grep", mode = "n" },
	{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Telescope buffers", mode = "n" },
	{ "<leader>ht", "<cmd>Telescope help_tags<cr>", desc = "Telescope help_tags", mode = "n" },
	--MaximilianLloyd/adjacent.nvim
	{ "<leader>fa", "<cmd>Telescope adjacent<cr>", desc = "Telescope adjacent", mode = "n" },
	--princejoogie/dir-telescope.nvim
	{ "<leader>dfg", "<cmd>Telescope dir live_grep<cr>", desc = "Telescope dir live_grep", mode = "n" },
	{ "<leader>dff", "<cmd>Telescope dir find_files<cr>", desc = "Telescope dir find_files", mode = "n" },
	--Verf/telescope-everything.nvim
	{ "<leader>es", "<cmd>Telescope everything<cr>", desc = "Telescope everything", mode = "n" },
	--nvim-telescope/telescope-file-browser.nvim
	{ "<leader>br", "<cmd>Telescope file_browser<cr>", desc = "Telescope file_browser", mode = "n" },
	--nvim-telescope/telescope-media-files.nvim
	{ "<leader>mf", "<cmd>Telescope media_files<cr>", desc = "Telescope media_files", mode = "n" },
	--nvim-telescope/telescope-frecency.nvim
	{ "<leader>R", "<cmd>Telescope frecency<cr>", desc = "Telescope frecency", mode = "n" },
	--jvgrootveld/telescope-zoxide
	{ "<leader>zi", "<cmd>Telescope zoxide list<cr>", desc = "Telescope zoxide list", mode = "n" },
	--jonarrien/telescope-cmdline.nvim
	{ "Q", "<cmd>Telescope cmdline<cr>", desc = "Telescope cmdline", mode = "n" },
	--nvim-telescope/telescope-dap.nvim
	--alduraibi/telescope-glyph.nvim
	{ "<leader>gyp", "<cmd>Telescope glyph<cr>", desc = "Telescope glyph", mode = "n" },
	--xiyaowong/telescope-emoji.nvim
	{ "<leader>emj", "<cmd>Telescope emoji<cr>", desc = "Telescope emoji", mode = "n" },
	--olacin/telescope-gitmoji.nvim
	{ "<leader>gmj", "<cmd>Telescope gitmoji<cr>", desc = "Telescope gitmoji", mode = "n" },
	--coffebar/neovim-project
	{ "<leader>pr", "<cmd>NeovimProjectLoadRecent<cr>", desc = "NeovimProjectLoadRecent", mode = "n" },
	{
		"<leader>pj",
		"<cmd>Telescope neovim-project discover<cr>",
		desc = "Telescope neovim-project discover",
		mode = "n",
	},
	{
		"<leader>ph",
		"<cmd>Telescope neovim-project history<cr>",
		desc = "Telescope neovim-project history",
		mode = "n",
	},
	--piersolenski/telescope-import.nvim
	{ "<leader>imp", "<cmd>Telescope import<cr>", desc = "Telescope import", mode = "n" },
	--tsakirist/telescope-lazy.nvim
	{ "<leader>lzy", "<cmd>Telescope lazy<cr>", desc = "Telescope lazy", mode = "n" },
	--polirritmico/telescope-lazy-plugins.nvim
	{ "<leader>lzp", "<cmd>Telescope lazy_plugins<cr>", desc = "Telescope lazy_plugins", mode = "n" },
	--ryanmsnyder/toggleterm-manager.nvim
	{ "<leader>trm", "<cmd>Telescope toggleterm_manager<cr>", desc = "Telescope toggleterm_manager", mode = "n" },
	--debugloop/telescope-undo.nvim
	{ "<leader>und", "<cmd>Telescope undo<cr>", desc = "Telescope undo" },
	--AckslD/nvim-neoclip.lua
	{ "<leader>clp", "<cmd>Telescope neoclip<cr>", desc = "Telescope neoclip" },
	--nvim-telescope/telescope-bibtex.nvim
	{ "<leader>bib", "<cmd>Telescope bibtex<cr>", desc = "Telescope bibtex" },
})
