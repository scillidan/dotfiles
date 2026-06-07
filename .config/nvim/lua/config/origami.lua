require("origami").setup({
  foldtext = {
    padding = 1,
    lineCount = {
      template = " %d ",
      hlgroup = "Normal",
    },
    diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
    gitsignsCount = true,
  },
  autoFold = {
    enabled = true,
    kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
  },
})
