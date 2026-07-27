local userhome = os.getenv("USERHOME")

require("devdocs").setup({
  ensure_installed = {
    "html",
    "css",
    "javascript",
    "http"
  },
  search_dirs = {
    vim.fn.stdpath("data") .. "/devdocs/docs",
    vim.fn.expand(userhome .. "/Local/Document/devdocs")
  },
  browser = "reader",
  include_documents = {
    "godot~4.6",
  },
  exclude_documents = { "Linux Man Pages" },
  -- picker = "telescope",
})
