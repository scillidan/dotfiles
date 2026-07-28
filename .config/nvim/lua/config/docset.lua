local userhome = os.getenv("USERHOME")

require("docset").setup({
  docset_dirs = {
    vim.fn.expand(userhome .. "/Local/Data/zeal"),
  },
  include_documents = { "Bash", "LaTeX" },
  exclude_documents = { "Linux Man Pages" },
  browser = { "reader", { "links", "-dump" } },
  -- picker = "telescope"
})
