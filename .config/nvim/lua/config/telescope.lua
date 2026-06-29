local actions = require("telescope.actions")
local z_utils = require("telescope._extensions.zoxide.utils")

require("telescope").setup({
	defaults = {
		layout_config = {
			center = {
				preview_width = 0.4,
				prompt_position = "bottom",
			},
			-- preview_cutoff = 120,
		},
		border = false,
		prompt_prefix = ": ",
		selection_caret = "  ",
		multi_icon = "-",
		mappings = {
			i = {
				["<esc>"] = actions.close,
			},
		},
	},
	pickers = {
		find_files = {
			-- theme = "ivy",
			-- layout_config = {
			-- 	prompt_position = "bottom",
			-- 	height = 0.5,
			-- 	preview_width = 0.5,
			-- },
			border = false,
			previewer = true,
		},
		live_grep = {
			-- theme = "dropdown",
			-- layout_config = {
			-- 	width = 0.8,
			-- 	height = 0.2,
			-- },
			border = false,
		},
	},
	extensions = {
		adjacent = {
			level = 1,
		},
		cmdline = {
			picker = {
				layout_config = {
					width = 100,
					height = 25,
				},
			},
		},
		dir = {
			hidden = true,
			no_ignore = false,
			show_preview = true,
			follow_symlinks = false,
		},
		lazy = {
			show_icon = true,
			actions_opts = {
				open_in_browser = {
					auto_close = false,
				},
				change_cwd_to_plugin = {
					auto_close = false,
				},
			},
			terminal_opts = {
				relative = "editor",
				style = "minimal",
				border = false,
				width = 0.5,
				height = 0.5,
			},
		},
		lazy_plugins = {
			lazy_config = vim.fn.stdpath("config") .. "/lua/config_lazy.lua",
		},
		recent_files = {},
		undo = {
			layout_strategy = "vertical",
			layout_config = {
				preview_height = 0.8,
			},
		},
		zoxide = {
			theme = "ivy",
			layout_config = {
				prompt_position = "bottom",
			},
			border = false,
		},
	},
})

for _, extensions in ipairs({
	"adjacent",
	"cmdline",
	"dir",
	"lazy",
	"lazy_plugins",
	"recent_files",
	"undo",
	"zoxide",
}) do
	require("telescope").load_extension(extensions)
end
