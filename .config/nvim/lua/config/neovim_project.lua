local env = require("env")

require("neovim-project").setup({
	projects = {
		env.home_dir .. "/Git",
		env.home_dir .. "/Proj",
		env.home_dir .. "/Fork",
	},
	datapath = vim.fn.stdpath("data"),
	last_session_on_startup = true,
	dashboard_mode = false,
	filetype_autocmd_timeout = 200,
	session_manager_opts = {
		autosave_ignore_dirs = {
			vim.fn.expand("~"),
			"/tmp",
		},
		autosave_ignore_filetypes = {
			"gitcommit",
			"toggleterm",
		},
	},
})
