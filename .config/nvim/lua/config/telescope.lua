local actions = require("telescope.actions")
local z_utils = require("telescope._extensions.zoxide.utils")

require("telescope").setup({
  defaults = {
    border = false,
    previewer = true,
    layout_config = {
    	preview_cutoff = 60,
    	center = { height = 0.7, width = 0.99, preview_cutoff = 1 },
    	horizontal = { width = 0.99, height = 0.99, preview_width = 0.5 },
    },
    multi_icon = "┃",
    mappings = { i = { ["<esc>"] = actions.close } },
    file_ignore_patterns = { "%.git/", "node_modules/", "site/", "public/", "%.venv/" },
    vimgrep_arguments = {
      "rg",
      "--hidden",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--glob", "!.git/**",
      "--glob", "!node_modules/**",
      "--glob", "!site/**",
      "--glob", "!public/**",
      "--glob", "!.venv/**",
    },
  },
  pickers = {
    find_files = { layout_strategy = "horizontal", previewer = true, hidden = true },
    live_grep = { layout_strategy = "horizontal", previewer = true }
  },
  extensions = {
    cmdline = { picker = { layout_config = { width = 100, height = 25 } } },
    lazy = {
      show_icon = true,
      actions_opts = {
        open_in_browser = { auto_close = false },
        change_cwd_to_plugin = { auto_close = false }
      },
      terminal_opts = {
        relative = "editor",
        style = "minimal",
        border = false,
        width = 0.5,
        height = 0.5,
      },
    },
    lazy_plugins = { lazy_config = vim.fn.stdpath("config") .. "/lua/config_lazy.lua" },
    recent_files = {},
    undo = { layout_strategy = "vertical", layout_config = { preview_height = 0.8 } },
    zoxide = { layout_strategy = "center", border = false }
  }
})

for _, extensions in ipairs({
  "cmdline",
  "lazy",
  "lazy_plugins",
  "recent_files",
  "undo",
  "zoxide",
}) do
  require("telescope").load_extension(extensions)
end
