require("bookmarks").setup({
    default_mappings = true,
    db_path = vim.fn.stdpath('data') .. '/bookmarks.db'
})

require("telescope").load_extension("bookmarks")
