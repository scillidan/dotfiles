require("translate").setup({
	default = {
		command = "translate_shell",
		output = "floating",
	},
	preset = {
		output = {
			split = {
				min_size = 8,
			},
		},
	},
})
