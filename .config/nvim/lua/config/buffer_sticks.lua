--https://github.com/ahkohd/buffer-sticks.nvim?tab=readme-ov-file#configuration
require("buffer-sticks").setup({
	preview = {
		float = {
			border = "none",
		},
	},
	filter = { buftypes = { "terminal" } },
	highlights = {
		active = { link = "Statement" },
		alternate = { link = "StorageClass" },
		inactive = { link = "Whitespace" },
		active_modified = { link = "Constant" },
		alternate_modified = { link = "Constant" },
		inactive_modified = { link = "Constant" },
		label = { link = "Comment" },
		filter_selected = { link = "Statement" },
		filter_title = { link = "Comment" },
		list_selected = { link = "Statement" },
	},
})
