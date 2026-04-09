require("nvim-treesitter.configs").setup({
	autotag = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
	highlight = {
		enable = true,
		disable = { "kdl" },
	},
	indent = {
		enable = true,
		disable = {},
	},
})
