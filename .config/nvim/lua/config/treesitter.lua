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
  "jsonc",
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
  "tmux",
  "toml",
  "tsv",
  "typescript",
  "typst",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
  "zathurarc",
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

require("nvim-treesitter.configs").setup({
  autotag = {
    enable = true,
  },
  auto_install = true,
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  ensure_installed = parsers,
  highlight = {
    enable = true,
    disable = { "kdl" },
  },
  indent = {
    enable = true,
    disable = {},
  },
})
