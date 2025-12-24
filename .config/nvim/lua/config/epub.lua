require("epub").setup({
  auto_open = false,
  output_dir = vim.fn.stdpath("cache") .. "/epub_reader",
  data_dir = vim.fn.stdpath("data") .. "/epub_reader",
})
