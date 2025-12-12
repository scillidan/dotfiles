require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"pylsp",
		"marksman",
		"bashls",
		"jsonls",
		"html",
		"cssls",
		"texlab",
		"tinymist",
		-- "jdtls",
		-- "debugpy",
		-- "ltex-ls-plus",
		-- "tailwindcss",
		-- "emmet_language_server",
		-- "nextls",
	},
})
