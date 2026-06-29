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

	-- Key
	{
		"<leader>!",
		'<Cmd>lua require("which-key").show({ global = false })<CR>',
		desc = "which-key.show",
		mode = "n",
	},
	-- Snippet
	--  { "<C-k>", '<Cmd>lua require("luasnip").expand()<CR>', desc = "luasnip expand", mode = { "i", "s" } },
	--  { "<C-h>", '<Cmd>lua require("luasnip").jump(-1)<CR>', desc = "luasnip jump(-1)", mode = { "i", "s" } },
	--  { "<C-l>", '<Cmd>lua require("luasnip").jump(1)<CR>', desc = "luasnip jump(1)", mode = { "i", "s" } },

	-- Markdown
	{ "<leader>mh", "<Cmd>MDHeadersCurrent<CR>", desc = "MDHeadersCurrent", mode = "n" },
	-- LaTeX
	{ "<leader>ci", "<Cmd>CiteInsert<CR>", desc = "CiteInsert" },
	{ "<leader>cp", "<Cmd>CitePeek<CR>", desc = "CitePeek" },
	{ "<leader>co", "<Cmd>CiteOpen<CR>", desc = "CiteOpen" },
	{ "<leader>cn", "<Cmd>CiteNote<CR>", desc = "CiteNote" },

	-- Explorer
	{ "-", "<Cmd>Oil<CR>", desc = "Oil", mode = "n" },
	{ "<leader>-", "<Cmd>Yazi<CR>", desc = "Open yazi at the current file", mode = { "n", "v" } },
	{ "<leader>cw", "<Cmd>Yazi cwd<CR>", desc = "Open the file manager in nvim's working directory" },
	{ "<C-up>", "<Cmd>Yazi toggle<CR>", desc = "Resume the last yazi session" },
	-- Buffer
	{ "<leader>gb", '<Cmd>lua require("snipe").open_buffer_menu()<CR>', desc = "Open Snipe buffer menu", mode = "n" },
	-- Window
	{
		{ "<C-W><C-M>", "<Cmd>WinShift<CR>", desc = "WinShift" },
		{ "<C-W>m", "<Cmd>WinShift<CR>", desc = "WinShift" },
		{ "<C-W>X", "<Cmd>WinShift swap<CR>", desc = "WinShift swap" },
		{ "<C-M-H>", "<Cmd>WinShift left<CR>", desc = "WinShift left" },
		{ "<C-M-J>", "<Cmd>WinShift down<CR>", desc = "WinShift down" },
		{ "<C-M-K>", "<Cmd>WinShift up<CR>", desc = "WinShift up" },
		{ "<C-M-L>", "<Cmd>WinShift right<CR>", desc = "WinShift right" },
	},
	-- Session
	{ "<leader>wr", "<Cmd>AutoSession search<CR>", desc = "AutoSession search" },
	{ "<leader>ws", "<Cmd>AutoSession save<CR>", desc = "AutoSession save" },
	{ "<leader>wa", "<Cmd>AutoSession toggle<CR>", desc = "AutoSession toggle" },
	{ "<leader>wd", "<Cmd>AutoSession delete<CR>", desc = "AutoSession delete" },

	-- Goto
	{ "gR", "<Cmd>Glance references<CR>", desc = "Glance references<CR>", mode = "n" },
	{ "gD", "<Cmd>Glance definitions<CR>", desc = "Glance definitions<CR>", mode = "n" },
	{ "gY", "<Cmd>Glance type_definitions<CR>", desc = "Glance type_definitions<CR>", mode = "n" },
	{ "gM", "<Cmd>Glance implementations<CR>", desc = "Glance implementations<CR>", mode = "n" },
	-- Jump
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
	-- Multiple-cursor
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
	-- Replace
	{
		"<leader>gf",
		'<Cmd>lua require("grug-far").open({ engine = "astgrep" })<CR>',
		desc = "grug-far.open",
		mode = "n",
	},
	-- Sort
	{ "<leader>ts", "<Cmd>TSSort list<CR>", desc = "TSSort list", mode = "n" },
	{ "<leader>ts", "<Esc><Cmd>TSSort list<CR>", desc = "TSSort list", mode = "v" },
	-- Yank
	{ "<leader>clp", "<Cmd>Telescope neoclip<CR>", desc = "Telescope neoclip" },

	-- telescope.nvim
	{ "<leader>kk", "<Cmd>Telescope keymaps<CR>", desc = "Telescope keymaps", mode = "n" },
	{ "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Telescope find_files", mode = "n" },
	{ "<leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Telescope live_grep", mode = "n" },
	{ "<leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Telescope buffers", mode = "n" },
	{ "<leader>ht", "<Cmd>Telescope help_tags<CR>", desc = "Telescope help_tags", mode = "n" },

	{ "<leader>fa", "<Cmd>Telescope adjacent<CR>", desc = "Telescope adjacent", mode = "n" },

	{ "Q", "<Cmd>Telescope cmdline<CR>", desc = "Telescope cmdline", mode = "n" },

	{ "<leader>dfg", "<Cmd>Telescope dir live_grep<CR>", desc = "Telescope dir live_grep", mode = "n" },
	{ "<leader>dff", "<Cmd>Telescope dir find_files<CR>", desc = "Telescope dir find_files", mode = "n" },

	{ "<leader>lzy", "<Cmd>Telescope lazy<CR>", desc = "Telescope lazy", mode = "n" },
	{ "<leader>lzp", "<Cmd>Telescope lazy_plugins<CR>", desc = "Telescope lazy_plugins", mode = "n" },

	{
		"<leader>R",
		"<Cmd>lua require('telescope').extensions.recent_files.pick()<CR>",
		desc = "Telescope recent_files",
		mode = "n",
	},

	{ "<leader>und", "<Cmd>Telescope undo<CR>", desc = "Telescope undo" },

	{ "<leader>zi", "<Cmd>Telescope zoxide list<CR>", desc = "Telescope zoxide list", mode = "n" },

	-- Debug
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
	-- Development
	{ "<leader>vv", "<Cmd>LoveRun<CR>", desc = "LoveRun" },
	{ "<leader>vs", "<Cmd>LoveStop<CR>", desc = "LoveStop" },
})
