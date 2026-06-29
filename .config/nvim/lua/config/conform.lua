require("conform").setup({
	formatters = {
		["tex-fmt"] = {
			prepend_args = { "--nowrap" },
		},
	},
	formatters_by_ft = {
		-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
		-- python = { "isort", "black" },
		bib = { "bibtex-tidy" },
		css = { "prettierd" },
		html = { "prettierd" },
		javascript = { "prettierd", "eslint_d" },
		javascriptreact = { "prettierd", "eslint_d" },
		json = { "prettierd" },
		lua = { "stylua" },
		markdown = {},
		python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		sh = { "shfmt" },
		tex = { "tex-fmt" },
		typescript = { "prettierd", "eslint_d" },
		typescriptreact = { "prettierd", "eslint_d" },
		yaml = { "yamlfmt" },
		["_"] = { "trim_whitespace" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	format_on_save = {
		timeout_ms = 1500,
		undojoin = true,
	},
	format_after_save = {
		lsp_format = "fallback",
	},
	log_level = vim.log.levels.ERROR,
})
