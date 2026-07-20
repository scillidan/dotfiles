local is_termux = vim.env.TERMUX_VERSION ~= nil

local parsers = {
  "bash",
  "c",
  "comment",
  "cpp",
  "css",
  "csv",
  "desktop",
  "diff",
  "editorconfig",
  "gdscript",
  "gitattributes",
  "gitignore",
  "html",
  "ini",
  "javascript",
  "json",
  "just",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "powershell",
  "python",
  "query",
  "rasi",
  "regex",
  "requirements",
  "rst",
  "toml",
  "tsv",
  "typescript",
  "typst",
  "vim",
  "vimdoc",
  "xml",
  "yaml"
}

local exclude_parsers = {
  "json",
  "jsonc",
}

local function contains(list, x)
  for _, v in ipairs(list) do
    if v == x then
      return true
    end
  end
  return false
end

if is_termux then
  local filtered = {}
  for _, parser in ipairs(parsers) do
    if not contains(exclude_parsers, parser) then
      table.insert(filtered, parser)
    end
  end
  parsers = filtered
end

require("nvim-treesitter").setup {
  install_dir = vim.fn.stdpath("data") .. "/site",
}

require("nvim-treesitter").install(parsers):wait(300000)

vim.api.nvim_create_autocmd("FileType", {
  pattern = parsers,
  callback = function()
    vim.treesitter.start()
  end,
})
