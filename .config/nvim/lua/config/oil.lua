require("oil").setup({
	default_file_explorer = true,
	columns = {},
	keymaps = {
		["<C-h>"] = false,
		["<C-l>"] = false,
		["<C-k>"] = false,
		["<C-j>"] = false,
		["g."] = false,
		["<BS>"] = { "actions.parent", mode = "n" },
		["-"] = { "actions.close", mode = "n" },
		["cd"] = { "actions.open_cwd", mode = "n" },
		["|"] = { "actions.select", opts = { vertical = true } },
		["%"] = { "actions.select", opts = { horizontal = true } },
		["<C-r>"] = "actions.refresh",
		["hi"] = "actions.toggle_hidden",
		["<leader>y"] = "actions.yank_entry",
		["gd"] = {
			desc = "Toggle file detail view",
			callback = function()
				detail = not detail
				if detail then
					require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
				else
					require("oil").set_columns({ "icon" })
				end
			end,
		},
	},
	win_options = {
		signcolumn = "yes:2",
	},
	delete_to_trash = true,
})
