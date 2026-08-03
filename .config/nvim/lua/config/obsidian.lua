local userhome = os.getenv("USERHOME")

vim.opt.conceallevel = 1

require("obsidian").setup({
  workspaces = {
    {
      name = "cheats",
      path = userhome .. "/Share/files/cheats",
    },
  },
  note_id_func = function(title)
    if title then
      return title:gsub(" ", "-")
    end
    return tostring(os.time())
  end,
  preferred_link_style = "wiki",
  picker = {
    name = "telescope.nvim",
  },
  ui = { enable = true },
})
