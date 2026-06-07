require("lint").linters_by_ft = {
	lua = { "luacheck" },
	sh = { "shellcheck" },
	dockerfile = { "hadolint" },
	json = { "jsonlint" },
	yaml = { "yamllint" },
	-- javascript = { "eslint_d" },
	-- typescript = { "eslint_d" },
	-- javascriptreact = { "eslint_d" },
	-- typescriptreact = { "eslint_d" },
}
