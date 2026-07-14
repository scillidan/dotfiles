local fzf_oil_float = vim.tbl_deep_extend("force", require("fzf-oil").float, {
  border = "single",
  win_options = {
    winhl = "NormalFloat:FzfLuaNormal,FloatBorder:FzfLuaBorder,FloatTitle:FzfLuaTitle",
    signcolumn = "no",
  },
})

local fzf_oil_preview = vim.tbl_deep_extend("force", require("fzf-oil").preview_win, {
  win_options = {
    winhl = "NormalFloat:FzfLuaNormal,FloatBorder:FzfLuaBorder,FloatTitle:FzfLuaPreviewTitle",
    signcolumn = "no",
    foldcolumn = "0",
  },
})

require("oil").setup({
  default_file_explorer = true,
  view_options = {
    show_hidden = true,
  },
  columns = {},
  keymaps = require("config.keys.oil"),
  win_options = {
    signcolumn = "yes:2",
  },
  delete_to_trash = true,
  float = fzf_oil_float,
  preview_win = fzf_oil_preview,
})
