require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"pylsp",
		"marksman",
		"bashls",
		"jsonls",
		"html",
		"cssls",
		-- "debugpy",
		-- "ltex-ls-plus",
		-- "tailwindcss",
		-- "emmet_language_server",
		-- "nextls",
	},
})
