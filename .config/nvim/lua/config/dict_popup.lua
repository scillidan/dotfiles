return {
	normal_mapping = "<Leader>h",
	visual_mapping = "<Leader>h",
	visual_reg = "*",
	stack = false,
	buffer_mappings = { -- defaults
		close = { "<Esc>", "q" },
		next_definition = { "}" },
		previous_definition = { "{" },
		jump_back = { "<C-o>" },
		jump_forward = { "<C-i>", "<Tab>" },
		jump_definition = { "<C-]>" },
	},
}
