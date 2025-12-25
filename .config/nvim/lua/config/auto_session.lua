require("auto-session").setup({
	---@module "auto-session"
	---@type AutoSession.Config
	suppress_dirs = {
		(vim.fn.has("unix") == 1 and os.getenv("HOME")) or (vim.fn.has("win32") == 1 and os.getenv("USERHOME")),
	},
	-- log_level = "debug"
	session_lens = {
		picker = telescope,
		picker_opts = {
			border = false,
		},
	},
})
