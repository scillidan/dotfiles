local actions = require("telescope.actions")
local bibtex_actions = require("telescope-bibtex.actions")
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
		bibtex = {
			-- Depth for the *.bib file
			depth = 1,
			-- Custom format for citation label
			custom_formats = {},
			-- Format to use for citation label.
			-- Try to match the filetype by default, or use 'plain'
			format = "",
			-- Path to global bibliographies (placed outside of the project)
			global_files = {},
			-- Define the search keys to use in the picker
			search_keys = { "author", "year", "title" },
			-- Template for the formatted citation
			citation_format = "{{author}} ({{year}}), {{title}}.",
			-- Only use initials for the authors first name
			citation_trim_firstname = true,
			-- Max number of authors to write in the formatted citation
			-- following authors will be replaced by "et al."
			citation_max_auth = 2,
			-- Context awareness disabled by default
			context = false,
			-- Fallback to global/directory .bib files if context not found
			-- This setting has no effect if context = false
			context_fallback = true,
			-- Wrapping in the preview window is disabled by default
			wrap = false,
			-- user defined mappings
			mappings = {
				i = {
					["<CR>"] = bibtex_actions.key_append("%s"), -- format is determined by filetype if the user has not set it explictly
					["<C-e>"] = bibtex_actions.entry_append,
					["<C-c>"] = bibtex_actions.citation_append("{{author}} ({{year}}), {{title}}."),
				},
			},
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
		emoji = {
			action = function(emoji)
				vim.fn.setreg("*", emoji.value)
				print([[Press p or "*p to paste this emoji]] .. emoji.value)
			end,
		},
		everything = {
			es_path = "es",
			case_sensitity = false,
			whole_word = false,
			match_path = false,
			sort = false,
			regex = true,
			offset = 0,
			max_results = 100,
		},
		file_browser = {
			-- theme = "ivy",
			border = false,
		},
		gitmoji = {},
		heading = {
			treesitter = true,
			picker_opts = {
				layout_config = {
					width = 0.8,
					preview_width = 0.5,
				},
				layout_strategy = "horizontal",
			},
		},
		import = {
			insert_at_top = true,
			custom_languages = {
				{
					extensions = { "js", "ts" },
					filetypes = { "vue" },
					insert_at_line = 2,
					regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
				},
			},
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
		media_files = {
			filetypes = {
				"png",
				"webp",
				"jpg",
				"jpeg",
				"svg",
				"gif",
				"mp4",
				"webm",
				"mkv",
				"pdf",
				"epub",
				"ttf",
				"otf",
			},
			find_cmd = "rg",
		},
		recent_files = {},
		toggleterm_manager = {},
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
	"dap",
	"dir",
	"emoji",
	"file_browser",
	-- "frecency",
	"gitmoji",
	"glyph",
	"heading",
	"import",
	"lazy",
	"lazy_plugins",
	"media_files",
	"recent_files",
	"toggleterm_manager",
	"undo",
	"zoxide",
}) do
	require("telescope").load_extension(extensions)
end

if vim.fn.has("win32") == 1 then
	require("telescope").load_extension("everything")
end
