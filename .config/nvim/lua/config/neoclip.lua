require("neoclip").setup({
	keys = require("config.keys.neoclip"),
  history = 10000,
  enable_persistent_history = true,
  db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
  preview = true,
  default_register = '"',
  default_register_macros = "q",
  enable_macro_history = true,
})
