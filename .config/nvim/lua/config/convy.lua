--https://github.com/necrom4/convy.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
return {
	opts = {
		notifications = true,
		separator = " ",
		window = {
			blend = 25,
			border = "line",
		},
	},
	keys = {
		{
			"<leader>cc",
			":Convy<CR>",
			desc = "Convert (interactive selection)",
			mode = { "n", "v" },
			silent = true,
		},
		{
			"<leader>cd",
			":Convy auto dec<CR>",
			desc = "Convert to decimal",
			mode = { "n", "v" },
			silent = true,
		},
		{
			"<leader>cs",
			":ConvySeparator<CR>",
			desc = "Set convertion separator (visual selection)",
			mode = { "v" },
			silent = true,
		},
	},
}
