local env = require("env")

require("auto-session").setup({
	---@module "auto-session"
	---@type AutoSession.Config
	suppress_dirs = {
		env.home_dir,
	},
	-- log_level = "debug"
})
