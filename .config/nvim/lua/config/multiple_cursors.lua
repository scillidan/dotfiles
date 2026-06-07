require("multiple-cursors").setup({
	pre_hook = function()
		vim.cmd("set nocul")
		vim.cmd("NoMatchParen")
	end,
	post_hook = function()
		vim.cmd("set cul")
		vim.cmd("DoMatchParen")
	end,
})
