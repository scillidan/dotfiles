local userhome = os.getenv("USERHOME")

require("toggleterm").setup({
  -- insert_mappings = false, -- Relevant
  -- terminal_mappings = false, --  Relevant
  shade_terminals = false,
  start_in_insert = true,
  size = vim.o.columns * 0.1,
  open_mapping = [[<c-\>]],
  shell = vim.o.shell,
  shellcmdflag = userhome and ("/k " .. userhome .. "/Share/dotfiles.win/Scoop/clink/init.cmd") or "/k",
})
