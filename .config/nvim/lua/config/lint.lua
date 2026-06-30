require("lint").linters_by_ft = {
  dockerfile = { "hadolint" },
  -- markdown = { "vale" },
  sh = { "shellcheck" },
  yaml = { "yamllint" },
  ["*"] = { "codespell" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
