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

-- Polyfill for telescope.nvim 0.1.x compatibility with nvim-treesitter main branch.
-- The main branch removed legacy module functions that telescope 0.1.x still uses.
local ts_parsers = require("nvim-treesitter.parsers")
if not ts_parsers.ft_to_lang then
  ts_parsers.ft_to_lang = function(ft)
    return vim.treesitter.language.get_lang(ft) or ft
  end
end
if not ts_parsers.get_parser then
  ts_parsers.get_parser = function(bufnr, lang)
    return vim.treesitter.get_parser(bufnr, lang)
  end
end

local configs_ok, configs = pcall(require, "nvim-treesitter.configs")
if not configs_ok or type(configs) ~= "table" then
  configs = {
    is_enabled = function(_, lang, _)
      return pcall(vim.treesitter.language.inspect, lang)
    end,
    get_module = function(_)
      return { additional_vim_regex_highlighting = false }
    end,
  }
  package.loaded["nvim-treesitter.configs"] = configs
else
  if not configs.is_enabled then
    configs.is_enabled = function(_, lang, _)
      return pcall(vim.treesitter.language.inspect, lang)
    end
  end
  if not configs.get_module then
    configs.get_module = function(_)
      return { additional_vim_regex_highlighting = false }
    end
  end
end
