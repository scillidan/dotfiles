require("cheatsheet").setup({
	bundled_cheatsheets = {
		enabled = {
			"default",
			"lua",
			-- "nerd-fonts",
			-- "netrw",
			"regex",
			"unicode",
		},
	},
	bundled_plugin_cheatsheets = {
		enabled = {
			-- "vim-sandwich",
		},
	},
	include_only_installed_plugins = true,
	telescope_mappings = {
		["<CR>"] = require("cheatsheet.telescope.actions").select_or_fill_commandline,
		["<A-CR>"] = require("cheatsheet.telescope.actions").select_or_execute,
		["<C-Y>"] = require("cheatsheet.telescope.actions").copy_cheat_value,
		["<C-E>"] = require("cheatsheet.telescope.actions").edit_user_cheatsheet,
	},
})
