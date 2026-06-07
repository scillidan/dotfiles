require("neovim-project").setup({
	projects = {
		(vim.fn.has("unix") == 1 and os.getenv("HOME"))
			or (vim.fn.has("win32") == 1 and os.getenv("USERHOME")) .. "/Usr/Git",
		(vim.fn.has("unix") == 1 and os.getenv("HOME"))
			or (vim.fn.has("win32") == 1 and os.getenv("USERHOME")) .. "/Usr/Proj",
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
