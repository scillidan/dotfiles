-- YAML
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "yaml" },
  callback = function()
    vim.bo.expandtab = true
  end,
})

-- Markdown / Rst / Text
vim.api.nvim_create_augroup("MarkdownRstText", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "MarkdownRstText",
  pattern = { "markdown", "rst", "text" },
  callback = function()
    vim.wo.list = true
    vim.wo.listchars = "tab:··,trail:-,nbsp:+,eol:¬"
  end,
})

-- conform.nvim
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

-- godotdev.nvim
vim.api.nvim_create_augroup("GodotIndent", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "GodotIndent",
  pattern = { "gdscript", "cs" },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
  end,
})
