require("oil").setup({
  default_file_explorer = true,
  columns = {},
  keymaps = require("config.keys.oil"),
  win_options = {
    signcolumn = "yes:2",
  },
  delete_to_trash = true,
})
