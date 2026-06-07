local glance = require("glance")
local actions = glance.actions

glance.setup({
  height = 20,
  zindex = 45,
  preview_win_opts = {
    relativenumber = false,
  },
  list = {
    position = "right",
    width = 0.5,
  },
  indent_lines = {
    icon = "",
  },
  use_trouble_qf = true,
})
