require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "yapf", "isort", "black" },
		typst = { "tinymist" },
		tex = { "tex-fmt" },
		bib = { "bibtex-tidy" },
		sh = { "shfmt" },
		json = { "prettierd" },
		yaml = { "prettierd" },
		toml = { "taplo" },
		html = { "prettierd" },
		css = { "prettierd" },
		javascript = { "prettierd", "eslint_d" },
		typescript = { "eslint_d" },
		javascriptreact = { "prettierd", "eslint_d" },
		typescriptreact = { "prettierd", "eslint_d" },
		-- ["*"] = { "codespell" },
		-- ["_"] = { "trim_whitespace" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	format_on_save = {
		lsp_format = "fallback",
		timeout_ms = 500,
	},
	format_after_save = {
		lsp_format = "fallback",
	},
	log_level = vim.log.levels.ERROR,
})
