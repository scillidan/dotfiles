local fzf_oil = require("fzf-oil")

local browser = fzf_oil.setup({
  border = "none",
  fzf_exec_opts = {
    winopts = {
      preview = {
        border = "none",
      },
    },
    fzf_opts = {
      ["--info"] = "hidden",
    },
  },
})

vim.keymap.set("n", "<leader>fo", browser.browse, { desc = "File browser" })
